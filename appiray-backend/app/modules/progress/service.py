from datetime import UTC, datetime, time, timedelta

from fastapi import HTTPException, status
from redis.asyncio import Redis
from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.core.config import get_settings
from app.core.enums import ProgressStatus
from app.modules.courses.models import Exercise, Lesson
from app.modules.gamification.quests import QuestService
from app.modules.gamification.service import GamificationService
from app.modules.progress.hearts import apply_heart_regen, start_refill_timer_if_needed
from app.modules.progress.models import (
    ExerciseAttempt,
    StreakFreeze,
    UserProgress,
    XPTransaction,
)
from app.modules.progress.schemas import AnswerResult, AnswerSubmit
from app.modules.users.models import User


class ProgressService:
    """
    Hearts / streak / economy rules (MVP defaults — all tunable via settings):
    - Start with MAX_HEARTS (default 5).
    - Wrong answer (normal lesson): -1 heart; cannot submit if hearts == 0.
      Hearts regenerate lazily: one every HEART_REFILL_MINUTES (no cron needed).
    - Correct answer: +XP_PER_CORRECT_ANSWER XP.
    - Completing a lesson: +lesson.xp_reward XP and +GEMS_PER_LESSON gems.
    - Reaching the daily XP goal: +GEMS_PER_DAILY_GOAL gems (once per day).
    - Practice mode (practice=True): never consumes hearts, grants a small
      PRACTICE_XP_REWARD / PRACTICE_GEMS_REWARD instead of lesson rewards.
    - Streak: +1 if last_active was yesterday; unchanged if already today;
      reset handled by daily worker when inactive > STREAK_GRACE_HOURS
      (unless a StreakFreeze covers the gap).
    """

    def __init__(self, db: AsyncSession, redis: Redis) -> None:
        self.db = db
        self.redis = redis
        self.settings = get_settings()

    async def submit_answer(self, user: User, data: AnswerSubmit) -> AnswerResult:
        apply_heart_regen(user, self.settings)

        if not data.practice and user.hearts <= 0:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="No hearts left. Come back later or refill.",
            )

        result = await self.db.execute(
            select(Exercise)
            .where(Exercise.id == data.exercise_id)
            .options(selectinload(Exercise.lesson).selectinload(Lesson.exercises))
        )
        exercise = result.scalar_one_or_none()
        if exercise is None:
            raise HTTPException(status_code=404, detail="Exercise not found")

        is_correct = self._normalize(data.answer) == self._normalize(exercise.correct_answer)
        self.db.add(
            ExerciseAttempt(
                user_id=user.id,
                exercise_id=exercise.id,
                is_correct=is_correct,
            )
        )

        xp_gained = 0
        gems_gained = 0
        lesson_completed = False

        if data.practice:
            # Practice/revision never costs hearts and grants small rewards.
            if is_correct:
                xp_gained = self.settings.PRACTICE_XP_REWARD
                gems_gained = self.settings.PRACTICE_GEMS_REWARD
                await self._award_xp(user, xp_gained, f"practice:{exercise.id}")
                user.gems += gems_gained
        elif is_correct:
            xp_gained = self.settings.XP_PER_CORRECT_ANSWER
            await self._award_xp(user, xp_gained, f"correct_answer:{exercise.id}")
            progress = await self._ensure_progress(user.id, exercise.lesson_id)
            if progress.status == ProgressStatus.LOCKED:
                progress.status = ProgressStatus.IN_PROGRESS
            lesson_completed = await self._maybe_complete_lesson(user, exercise.lesson, progress)
            if lesson_completed:
                gems_gained += self.settings.GEMS_PER_LESSON
                user.gems += self.settings.GEMS_PER_LESSON
        else:
            user.hearts = max(user.hearts - 1, 0)
            start_refill_timer_if_needed(user, self.settings)

        self._update_streak(user)
        user.last_active_at = datetime.now(UTC)

        daily_goal_reached = await self._check_daily_goal(user)

        await GamificationService(self.db, self.redis).add_weekly_xp(user, xp_gained)
        await QuestService(self.db).record_event(
            user,
            xp_gained=xp_gained,
            lesson_completed=lesson_completed,
            correct=is_correct and not data.practice,
        )

        await self.db.commit()
        await self.db.refresh(user)

        return AnswerResult(
            is_correct=is_correct,
            xp_gained=xp_gained,
            gems_gained=gems_gained,
            hearts=user.hearts,
            xp_total=user.xp_total,
            gems=user.gems,
            current_streak=user.current_streak,
            level=user.level,
            lesson_completed=lesson_completed,
            daily_goal_reached=daily_goal_reached,
        )

    async def list_progress(self, user_id: str) -> list[UserProgress]:
        result = await self.db.execute(select(UserProgress).where(UserProgress.user_id == user_id))
        return list(result.scalars().all())

    async def list_xp(self, user_id: str, limit: int = 50) -> list[XPTransaction]:
        result = await self.db.execute(
            select(XPTransaction)
            .where(XPTransaction.user_id == user_id)
            .order_by(XPTransaction.created_at.desc())
            .limit(limit)
        )
        return list(result.scalars().all())

    async def refill_hearts_with_gems(self, user: User) -> User:
        apply_heart_regen(user, self.settings)
        if user.hearts >= self.settings.MAX_HEARTS:
            raise HTTPException(status_code=400, detail="Hearts are already full")
        if user.gems < self.settings.GEM_COST_HEART_REFILL:
            raise HTTPException(status_code=400, detail="Not enough gems")
        user.gems -= self.settings.GEM_COST_HEART_REFILL
        user.hearts = self.settings.MAX_HEARTS
        user.heart_refill_at = None
        await self.db.commit()
        await self.db.refresh(user)
        return user

    async def buy_streak_freeze(self, user: User) -> StreakFreeze:
        if user.gems < self.settings.GEM_COST_STREAK_FREEZE:
            raise HTTPException(status_code=400, detail="Not enough gems")

        now = datetime.now(UTC)
        existing = await self.db.execute(
            select(StreakFreeze).where(
                StreakFreeze.user_id == user.id,
                StreakFreeze.used.is_(False),
                StreakFreeze.active_until >= now,
            )
        )
        if existing.scalars().first() is not None:
            raise HTTPException(status_code=409, detail="An active streak freeze already exists")

        user.gems -= self.settings.GEM_COST_STREAK_FREEZE
        freeze = StreakFreeze(
            user_id=user.id,
            active_from=now,
            active_until=now + timedelta(days=self.settings.STREAK_FREEZE_DAYS),
            used=False,
        )
        self.db.add(freeze)
        await self.db.commit()
        await self.db.refresh(freeze)
        return freeze

    async def update_daily_goal(self, user: User, daily_xp_goal: int) -> User:
        user.daily_xp_goal = daily_xp_goal
        await self.db.commit()
        await self.db.refresh(user)
        return user

    # Practice/revision tuning (MVP): flag exercises with >=30% error rate.
    PRACTICE_ERROR_THRESHOLD = 0.3

    async def select_practice_exercises(self, user_id: str, limit: int = 10) -> list[Exercise]:
        """MVP revision selection: exercises the user got wrong often.

        Aggregates ExerciseAttempt per exercise and keeps those with an error
        rate >= PRACTICE_ERROR_THRESHOLD, ranked by wrong-count desc. Isolated
        on purpose so it can later be replaced by a real spaced-repetition
        algorithm (e.g. SM-2) without touching the endpoint or the service.
        """
        rows = await self.db.execute(
            select(ExerciseAttempt.exercise_id, ExerciseAttempt.is_correct).where(
                ExerciseAttempt.user_id == user_id
            )
        )
        totals: dict[str, int] = {}
        wrongs: dict[str, int] = {}
        for exercise_id, is_correct in rows.all():
            totals[exercise_id] = totals.get(exercise_id, 0) + 1
            if not is_correct:
                wrongs[exercise_id] = wrongs.get(exercise_id, 0) + 1

        scored = [
            (exercise_id, wrongs.get(exercise_id, 0))
            for exercise_id, total in totals.items()
            if total and wrongs.get(exercise_id, 0) / total >= self.PRACTICE_ERROR_THRESHOLD
        ]
        scored.sort(key=lambda x: x[1], reverse=True)
        exercise_ids = [eid for eid, _ in scored[:limit]]
        if not exercise_ids:
            return []
        result = await self.db.execute(select(Exercise).where(Exercise.id.in_(exercise_ids)))
        return list(result.scalars().all())

    async def _ensure_progress(self, user_id: str, lesson_id: str) -> UserProgress:
        result = await self.db.execute(
            select(UserProgress).where(
                UserProgress.user_id == user_id,
                UserProgress.lesson_id == lesson_id,
            )
        )
        progress = result.scalar_one_or_none()
        if progress is None:
            progress = UserProgress(
                user_id=user_id,
                lesson_id=lesson_id,
                status=ProgressStatus.IN_PROGRESS,
            )
            self.db.add(progress)
            await self.db.flush()
        return progress

    async def _maybe_complete_lesson(
        self, user: User, lesson: Lesson, progress: UserProgress
    ) -> bool:
        if progress.status == ProgressStatus.COMPLETED:
            return False

        exercise_ids = {e.id for e in lesson.exercises}
        if not exercise_ids:
            return False

        result = await self.db.execute(
            select(ExerciseAttempt.exercise_id)
            .where(
                ExerciseAttempt.user_id == user.id,
                ExerciseAttempt.exercise_id.in_(exercise_ids),
                ExerciseAttempt.is_correct.is_(True),
            )
            .distinct()
        )
        correct_ids = set(result.scalars().all())
        if correct_ids != exercise_ids:
            return False

        progress.status = ProgressStatus.COMPLETED
        progress.score = 100
        progress.completed_at = datetime.now(UTC)
        await self._award_xp(user, lesson.xp_reward, f"lesson_complete:{lesson.id}")
        await GamificationService(self.db, self.redis).check_badges(user)
        return True

    async def _award_xp(self, user: User, amount: int, reason: str) -> None:
        if amount <= 0:
            return
        user.xp_total += amount
        user.level = max(1, (user.xp_total // 100) + 1)
        self.db.add(XPTransaction(user_id=user.id, amount=amount, reason=reason))

    async def _check_daily_goal(self, user: User) -> bool:
        """Award daily-goal gems once per day when today's XP >= goal."""
        today = datetime.now(UTC).date()
        if user.last_daily_goal_date == today:
            return True

        await self.db.flush()
        day_start = datetime.combine(today, time.min, tzinfo=UTC)
        result = await self.db.execute(
            select(func.coalesce(func.sum(XPTransaction.amount), 0)).where(
                XPTransaction.user_id == user.id,
                XPTransaction.created_at >= day_start,
            )
        )
        today_xp = int(result.scalar_one() or 0)
        if today_xp >= user.daily_xp_goal:
            user.gems += self.settings.GEMS_PER_DAILY_GOAL
            user.last_daily_goal_date = today
            return True
        return False

    def _update_streak(self, user: User) -> None:
        now = datetime.now(UTC)
        last = user.last_active_at
        if last is None:
            user.current_streak = 1
        else:
            last_day = last.astimezone(UTC).date()
            today = now.date()
            if last_day == today:
                pass
            elif last_day == today - timedelta(days=1):
                user.current_streak += 1
            else:
                user.current_streak = 1
        user.longest_streak = max(user.longest_streak, user.current_streak)

    @staticmethod
    def _normalize(value: str) -> str:
        return " ".join(value.strip().lower().split())
