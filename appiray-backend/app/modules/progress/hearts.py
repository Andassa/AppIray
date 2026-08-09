from datetime import UTC, datetime, timedelta

from app.core.config import Settings
from app.modules.users.models import User


def apply_heart_regen(user: User, settings: Settings) -> bool:
    """Lazily regenerate hearts based on elapsed time (no cron needed).

    One heart is regained every ``HEART_REFILL_MINUTES``. ``heart_refill_at``
    holds the timestamp of the next heart to regain; it is cleared once hearts
    are back to ``MAX_HEARTS``. Returns True if the user was mutated.
    """
    if user.heart_refill_at is None or user.hearts >= settings.MAX_HEARTS:
        return False

    now = datetime.now(UTC)
    refill_at = user.heart_refill_at
    if refill_at.tzinfo is None:
        refill_at = refill_at.replace(tzinfo=UTC)

    interval = timedelta(minutes=settings.HEART_REFILL_MINUTES)
    changed = False
    while user.hearts < settings.MAX_HEARTS and now >= refill_at:
        user.hearts += 1
        refill_at = refill_at + interval
        changed = True

    if user.hearts >= settings.MAX_HEARTS:
        user.heart_refill_at = None
    elif changed:
        user.heart_refill_at = refill_at
    return changed


def start_refill_timer_if_needed(user: User, settings: Settings) -> None:
    """Arm the refill timer the first time a user drops below max hearts."""
    if user.hearts < settings.MAX_HEARTS and user.heart_refill_at is None:
        user.heart_refill_at = datetime.now(UTC) + timedelta(minutes=settings.HEART_REFILL_MINUTES)
