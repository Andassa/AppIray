import enum


class UserRole(str, enum.Enum):
    USER = "user"
    ADMIN = "admin"


class ExerciseType(str, enum.Enum):
    MCQ = "mcq"
    TRANSLATE = "translate"
    LISTEN = "listen"
    SPEAK = "speak"


class ProgressStatus(str, enum.Enum):
    LOCKED = "locked"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"


class FriendshipStatus(str, enum.Enum):
    PENDING = "pending"
    ACCEPTED = "accepted"


class PublicationCategory(str, enum.Enum):
    HISTOIRE = "histoire"
    GEOGRAPHIE = "geographie"
    CULTURE = "culture"


class PublicationStatus(str, enum.Enum):
    DRAFT = "draft"
    PUBLISHED = "published"


class DevicePlatform(str, enum.Enum):
    IOS = "ios"
    ANDROID = "android"


class NotificationType(str, enum.Enum):
    STREAK_REMINDER = "streak_reminder"
    STREAK_AT_RISK = "streak_at_risk"
    LEAGUE_RESULT = "league_result"
    BADGE_EARNED = "badge_earned"
    FRIEND_REQUEST = "friend_request"
    QUEST_COMPLETED = "quest_completed"
    SYSTEM = "system"
