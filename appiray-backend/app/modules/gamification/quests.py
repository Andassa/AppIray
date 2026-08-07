from datetime import UTC, datetime

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.core.config import get_settings
from app.core.enums import NotificationType
from app.modules.gamification.models import DailyQuest, UserDailyQuest
from app.modules.notifications.models import Notification
from app.modules.progress.models import XPTransaction
from app.modules.users.models import User

# MVP daily quest pool. Kept small and static; can later be data-driven /
# rotated. `criteria.type` is matched against events emitted by ProgressService.
DEFAULT_QUEST_POOL: list[dict] = [
    {
        "title": "Complète 3 leçons",
        "description": "Termine 3 leçons aujourd'hui.",
        "criteria": {"type": "lessons_completed", "target": 3},
        "xp_reward": 15,
        "gem_reward": 10,
    },
    {
        "title": "Gagne 50 XP",
        "description": "Accumule 50 XP aujourd'hui.",
        "criteria": {"type": "xp_earned", "target": 50},
        "xp_reward": 10,
        "gem_reward": 10,
    },
    {
        "title": "Réponse parfaite",
        "description": "Obtiens une bonne réponse sur un exercice.",
        "criteria": {"type": "perfect_answer", "target": 1},
        "xp_reward": 5,
        "gem_reward": 5,
    },
]


class QuestService:
    def __init__(self, db: AsyncSession) -> None:
        self.db = db
        self.settings = get_settings()

    async def _ensure_pool(self) -> list[DailyQuest]:
        result = await self.db.execute(select(DailyQuest))
        quests = list(result.scalars().all())
        if quests:
            return quests
        quests = [DailyQuest(**spec) for spec in DEFAULT_QUEST_POOL]
        self.db.add_all(quests)
        await self.db.flush()
        return quests

    async def get_or_generate_today(self, user: User) -> list[UserDailyQuest]:
        today = datetime.now(UTC).date()
        result = await self.db.execute(
            select(UserDailyQuest)
            .where(UserDailyQuest.user_id == user.id, UserDailyQuest.date == today)
            .options(selectinload(UserDailyQuest.quest))
        )
        existing = list(result.scalars().all())
        if existing:
            return existing

        pool = await self._ensure_pool()
        created = [
            UserDailyQuest(user_id=user.id, quest_id=quest.id, date=today, progress=0)
            for quest in pool
        ]
        self.db.add_all(created)
        await self.db.flush()
        # Re-fetch with quest relationship loaded for serialization.
        result = await self.db.execute(
            select(UserDailyQuest)
            .where(UserDailyQuest.user_id == user.id, UserDailyQuest.date == today)
            .options(selectinload(UserDailyQuest.quest))
        )
        quests = list(result.scalars().all())
        await self.db.commit()
        return quests

    async def record_event(
        self,
        user: User,
        *,
        xp_gained: int = 0,
        lesson_completed: bool = False,
        correct: bool = False,
    ) -> None:
        """Advance today's quests from a single answer submission.

        Called by ProgressService; does not duplicate any business logic and
        never raises so it can't break the answer flow.
        """
        today = datetime.now(UTC).date()
        result = await self.db.execute(
            select(UserDailyQuest)
            .where(UserDailyQuest.user_id == user.id, UserDailyQuest.date == today)
            .options(selectinload(UserDailyQuest.quest))
        )
        user_quests = list(result.scalars().all())
        if not user_quests:
            return

        for uq in user_quests:
            if uq.completed_at is not None:
                continue
            criteria = uq.quest.criteria or {}
            qtype = criteria.get("type")
            target = int(criteria.get("target", 1))

            increment = 0
            if qtype == "lessons_completed" and lesson_completed:
                increment = 1
            elif qtype == "xp_earned":
                increment = max(xp_gained, 0)
            elif qtype == "perfect_answer" and correct:
                increment = 1

            if increment <= 0:
                continue

            uq.progress += increment
            if uq.progress >= target:
                uq.completed_at = datetime.now(UTC)
                self._award(user, uq)

    def _award(self, user: User, uq: UserDailyQuest) -> None:
        quest = uq.quest
        if quest.xp_reward > 0:
            user.xp_total += quest.xp_reward
            user.level = max(1, (user.xp_total // 100) + 1)
            self.db.add(
                XPTransaction(
                    user_id=user.id,
                    amount=quest.xp_reward,
                    reason=f"quest_complete:{quest.id}",
                )
            )
        if quest.gem_reward > 0:
            user.gems += quest.gem_reward
        self.db.add(
            Notification(
                user_id=user.id,
                type=NotificationType.QUEST_COMPLETED,
                payload={"quest_id": quest.id, "title": quest.title},
            )
        )
