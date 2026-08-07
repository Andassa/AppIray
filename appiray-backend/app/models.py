"""Import all SQLAlchemy models so Alembic and metadata see them."""

from app.modules.audio.models import AudioAsset
from app.modules.content.models import Publication, PublicationComment, PublicationLike
from app.modules.courses.models import Course, Exercise, Lesson, Unit
from app.modules.gamification.models import Badge, League, LeagueMembership, UserBadge
from app.modules.notifications.models import Notification
from app.modules.progress.models import ExerciseAttempt, UserProgress, XPTransaction
from app.modules.social.models import Friendship
from app.modules.users.models import User

__all__ = [
    "User",
    "Course",
    "Unit",
    "Lesson",
    "Exercise",
    "UserProgress",
    "ExerciseAttempt",
    "XPTransaction",
    "League",
    "LeagueMembership",
    "Badge",
    "UserBadge",
    "Friendship",
    "Publication",
    "PublicationLike",
    "PublicationComment",
    "AudioAsset",
    "Notification",
]
