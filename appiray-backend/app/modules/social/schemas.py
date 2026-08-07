from datetime import datetime

from pydantic import BaseModel, ConfigDict

from app.core.enums import FriendshipStatus


class FriendRequestCreate(BaseModel):
    friend_id: str


class FriendshipRead(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    user_id: str
    friend_id: str
    status: FriendshipStatus
    created_at: datetime


class FriendLeaderboardEntry(BaseModel):
    user_id: str
    username: str
    xp_total: int
    rank: int


class UserSearchResult(BaseModel):
    user_id: str
    username: str
    avatar_url: str | None
    xp_total: int
    # Relationship with the current user: "none" | "pending" | "accepted"
    friendship_status: str
