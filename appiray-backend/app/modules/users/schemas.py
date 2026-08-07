from datetime import datetime

from pydantic import BaseModel, ConfigDict, Field


class UserRead(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    email: str
    username: str
    role: str
    avatar_url: str | None
    xp_total: int
    current_streak: int
    longest_streak: int
    hearts: int
    level: int
    created_at: datetime
    last_active_at: datetime | None


class UserUpdate(BaseModel):
    username: str | None = Field(default=None, min_length=3, max_length=80)
