from datetime import datetime

from pydantic import BaseModel, ConfigDict, Field

from app.core.enums import ProgressStatus


class AnswerSubmit(BaseModel):
    exercise_id: str
    answer: str = Field(min_length=1)
    practice: bool = False


class AnswerResult(BaseModel):
    is_correct: bool
    xp_gained: int
    gems_gained: int = 0
    hearts: int
    xp_total: int
    gems: int = 0
    current_streak: int
    level: int
    lesson_completed: bool = False
    daily_goal_reached: bool = False


class DailyGoalUpdate(BaseModel):
    daily_xp_goal: int = Field(ge=10, le=200)


class HeartsStatus(BaseModel):
    hearts: int
    max_hearts: int
    heart_refill_at: datetime | None
    gems: int


class StreakFreezeRead(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    user_id: str
    active_from: datetime
    active_until: datetime
    used: bool


class PracticeExercise(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    lesson_id: str
    type: str
    content: dict
    audio_asset_id: str | None


class ProgressRead(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    user_id: str
    lesson_id: str
    status: ProgressStatus
    score: int
    completed_at: datetime | None


class XPTransactionRead(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    amount: int
    reason: str
    created_at: datetime
