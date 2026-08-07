import logging
from datetime import UTC, datetime, timedelta

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import AsyncSessionLocal
from app.core.enums import NotificationType
from app.modules.gamification.service import GamificationService
from app.modules.notifications.models import Notification
from app.modules.users.models import User

logger = logging.getLogger(__name__)


async def reset_inactive_streaks() -> None:
    """Daily job: reset streaks for users inactive beyond the grace window."""
    from app.core.config import get_settings

    settings = get_settings()
    cutoff = datetime.now(UTC) - timedelta(hours=settings.STREAK_GRACE_HOURS)

    async with AsyncSessionLocal() as session:
        result = await session.execute(
            select(User).where(
                User.current_streak > 0,
                User.last_active_at.is_not(None),
                User.last_active_at < cutoff,
            )
        )
        users = list(result.scalars().all())
        for user in users:
            user.current_streak = 0
            session.add(
                Notification(
                    user_id=user.id,
                    type=NotificationType.STREAK_REMINDER,
                    payload={"message": "Your streak was reset. Practice today!"},
                )
            )
        await session.commit()
        logger.info("Reset streaks for %s users", len(users))


async def close_weekly_leagues() -> None:
    """Weekly job: close leagues, promote/demote, open a new week."""
    async with AsyncSessionLocal() as session:
        service = GamificationService(session)
        await service.close_current_week()
        await session.commit()
        logger.info("Weekly leagues closed and new week opened")


async def register_scheduled_jobs() -> None:
    from app.workers.queue import get_task_queue

    queue = get_task_queue()
    queue.schedule_cron(
        "reset_inactive_streaks",
        reset_inactive_streaks,
        cron="0 3 * * *",
    )
    queue.schedule_cron(
        "close_weekly_leagues",
        close_weekly_leagues,
        cron="5 0 * * 1",
    )
    queue.start()
