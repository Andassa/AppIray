from datetime import datetime

from pydantic import BaseModel, ConfigDict, Field

from app.core.enums import ProgressStatus


class AnswerSubmit(BaseModel):
    exercise_id: str
    answer: str = Field(min_length=1)


class AnswerResult(BaseModel):
    is_correct: bool
    xp_gained: int
    hearts: int
    xp_total: int
    current_streak: int
    level: int
    lesson_completed: bool = False


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
