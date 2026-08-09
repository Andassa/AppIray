import logging
from datetime import UTC, datetime, timedelta

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import AsyncSessionLocal
from app.core.enums import NotificationType
from app.core.push import get_push_sender
from app.modules.gamification.service import GamificationService
from app.modules.notifications.models import DeviceToken, Notification
from app.modules.progress.models import StreakFreeze
from app.modules.users.models import User

logger = logging.getLogger(__name__)


async def _has_active_freeze(session: AsyncSession, user_id: str, now: datetime) -> bool:
    result = await session.execute(
        select(StreakFreeze).where(
            StreakFreeze.user_id == user_id,
            StreakFreeze.used.is_(False),
            StreakFreeze.active_until >= now,
        )
    )
    freeze = result.scalars().first()
    if freeze is None:
        return False
    # Consume the freeze so it protects a single lapse.
    freeze.used = True
    return True


async def reset_inactive_streaks() -> None:
    """Daily job: reset streaks for users inactive beyond the grace window,
    unless an active StreakFreeze covers the lapse (in which case it's consumed).
    """
    from app.core.config import get_settings

    settings = get_settings()
    now = datetime.now(UTC)
    cutoff = now - timedelta(hours=settings.STREAK_GRACE_HOURS)

    async with AsyncSessionLocal() as session:
        result = await session.execute(
            select(User).where(
                User.current_streak > 0,
                User.last_active_at.is_not(None),
                User.last_active_at < cutoff,
            )
        )
        users = list(result.scalars().all())
        reset_count = 0
        frozen_count = 0
        for user in users:
            if await _has_active_freeze(session, user.id, now):
                frozen_count += 1
                continue
            user.current_streak = 0
            reset_count += 1
            session.add(
                Notification(
                    user_id=user.id,
                    type=NotificationType.STREAK_REMINDER,
                    payload={"message": "Your streak was reset. Practice today!"},
                )
            )
        await session.commit()
        logger.info("Streak job: reset=%s protected_by_freeze=%s", reset_count, frozen_count)


async def notify_streak_at_risk() -> None:
    """Evening job: push a reminder to users whose streak is at risk.

    Heuristic (approximate on purpose): users with a streak > 0 who were active
    yesterday but not yet today. Fired a few hours before midnight. Uses the
    abstract PushSender (log-only until FCM/APNs is configured).
    """
    push = get_push_sender()
    now = datetime.now(UTC)
    today = now.date()
    yesterday = today - timedelta(days=1)

    async with AsyncSessionLocal() as session:
        result = await session.execute(
            select(User).where(
                User.current_streak > 0,
                User.last_active_at.is_not(None),
            )
        )
        users = list(result.scalars().all())
        notified = 0
        for user in users:
            if user.last_active_at is None:
                continue
            if user.last_active_at.astimezone(UTC).date() != yesterday:
                continue
            tokens_result = await session.execute(
                select(DeviceToken.token).where(DeviceToken.user_id == user.id)
            )
            tokens = list(tokens_result.scalars().all())
            session.add(
                Notification(
                    user_id=user.id,
                    type=NotificationType.STREAK_AT_RISK,
                    payload={"message": "Your streak is at risk — practice before midnight!"},
                )
            )
            if tokens:
                await push.send(
                    tokens=tokens,
                    title="Garde ta série !",
                    body="Ta série est en danger — pratique avant minuit.",
                    data={"type": NotificationType.STREAK_AT_RISK.value},
                )
            notified += 1
        await session.commit()
        logger.info("Streak-at-risk job: notified=%s", notified)


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
        "notify_streak_at_risk",
        notify_streak_at_risk,
        cron="0 21 * * *",
    )
    queue.schedule_cron(
        "close_weekly_leagues",
        close_weekly_leagues,
        cron="5 0 * * 1",
    )
    queue.start()
