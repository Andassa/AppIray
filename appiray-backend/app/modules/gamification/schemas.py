from datetime import date, datetime

from pydantic import BaseModel, ConfigDict, Field


class LeagueRead(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    name: str
    tier: int
    week_start: date
    week_end: date


class LeaderboardEntry(BaseModel):
    user_id: str
    username: str
    xp_this_week: int
    rank: int


class BadgeCreate(BaseModel):
    name: str
    description: str
    icon_url: str | None = None
    criteria: dict = Field(default_factory=dict)


class BadgeRead(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    name: str
    description: str
    icon_url: str | None
    criteria: dict


class UserBadgeRead(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    badge: BadgeRead
    earned_at: datetime


class DailyQuestRead(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    title: str
    description: str
    criteria: dict
    xp_reward: int
    gem_reward: int


class UserDailyQuestRead(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    quest: DailyQuestRead
    date: date
    progress: int
    completed_at: datetime | None
