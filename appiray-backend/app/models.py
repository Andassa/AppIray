"""Import all SQLAlchemy models so Alembic and metadata see them."""

from app.modules.audio.models import AudioAsset
from app.modules.auth.models import EmailVerificationToken, PasswordResetToken
from app.modules.content.models import Publication, PublicationComment, PublicationLike
from app.modules.courses.models import Course, Exercise, Lesson, Unit
from app.modules.gamification.models import (
    Badge,
    DailyQuest,
    League,
    LeagueMembership,
    UserBadge,
    UserDailyQuest,
)
from app.modules.notifications.models import DeviceToken, Notification
from app.modules.progress.models import (
    ExerciseAttempt,
    StreakFreeze,
    UserProgress,
    XPTransaction,
)
from app.modules.social.models import Friendship
from app.modules.users.models import User

__all__ = [
    "User",
    "PasswordResetToken",
    "EmailVerificationToken",
    "Course",
    "Unit",
    "Lesson",
    "Exercise",
    "UserProgress",
    "ExerciseAttempt",
    "XPTransaction",
    "StreakFreeze",
    "League",
    "LeagueMembership",
    "Badge",
    "UserBadge",
    "DailyQuest",
    "UserDailyQuest",
    "Friendship",
    "Publication",
    "PublicationLike",
    "PublicationComment",
    "AudioAsset",
    "Notification",
    "DeviceToken",
]
