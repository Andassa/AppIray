from datetime import UTC, datetime, timedelta

from fastapi import HTTPException, status
from redis.asyncio import Redis
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.core.config import get_settings
from app.core.enums import ProgressStatus
from app.modules.courses.models import Exercise, Lesson
from app.modules.gamification.service import GamificationService
from app.modules.progress.models import ExerciseAttempt, UserProgress, XPTransaction
from app.modules.progress.schemas import AnswerResult, AnswerSubmit
from app.modules.users.models import User


class ProgressService:
    """
    Hearts / streak rules (MVP defaults — adjustable via settings):
    - Start with MAX_HEARTS (default 5).
    - Wrong answer: -1 heart; cannot submit if hearts == 0.
    - Correct answer: +XP_PER_CORRECT_ANSWER XP.
    - Completing all exercises in a lesson: +lesson.xp_reward XP, status=completed.
    - Streak: +1 if last_active was yesterday (or first activity); unchanged if already today;
      reset handled by daily worker when inactive > STREAK_GRACE_HOURS.
    """

    def __init__(self, db: AsyncSession, redis: Redis) -> None:
        self.db = db
        self.redis = redis
        self.settings = get_settings()

    async def submit_answer(self, user: User, data: AnswerSubmit) -> AnswerResult:
        if user.hearts <= 0:
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
        lesson_completed = False

        if is_correct:
            xp_gained = self.settings.XP_PER_CORRECT_ANSWER
            await self._award_xp(user, xp_gained, f"correct_answer:{exercise.id}")
            progress = await self._ensure_progress(user.id, exercise.lesson_id)
            if progress.status == ProgressStatus.LOCKED:
                progress.status = ProgressStatus.IN_PROGRESS
            lesson_completed = await self._maybe_complete_lesson(user, exercise.lesson, progress)
        else:
            user.hearts = max(user.hearts - 1, 0)

        self._update_streak(user)
        user.last_active_at = datetime.now(UTC)

        await GamificationService(self.db, self.redis).add_weekly_xp(user, xp_gained)
        await self.db.commit()
        await self.db.refresh(user)

        return AnswerResult(
            is_correct=is_correct,
            xp_gained=xp_gained,
            hearts=user.hearts,
            xp_total=user.xp_total,
            current_streak=user.current_streak,
            level=user.level,
            lesson_completed=lesson_completed,
        )

    async def list_progress(self, user_id: str) -> list[UserProgress]:
        result = await self.db.execute(
            select(UserProgress).where(UserProgress.user_id == user_id)
        )
        return list(result.scalars().all())

    async def list_xp(self, user_id: str, limit: int = 50) -> list[XPTransaction]:
        result = await self.db.execute(
            select(XPTransaction)
            .where(XPTransaction.user_id == user_id)
            .order_by(XPTransaction.created_at.desc())
            .limit(limit)
        )
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
