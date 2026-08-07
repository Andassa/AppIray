from fastapi import APIRouter, Query

from app.core.deps import CurrentUser, DbSession
from app.modules.social.schemas import (
    FriendLeaderboardEntry,
    FriendRequestCreate,
    FriendshipRead,
    UserSearchResult,
)
from app.modules.social.service import SocialService

router = APIRouter(prefix="/social", tags=["social"])


@router.get("/users/search", response_model=list[UserSearchResult])
async def search_users(
    user: CurrentUser,
    db: DbSession,
    query: str = Query(min_length=1, max_length=80),
    limit: int = Query(default=20, ge=1, le=50),
) -> list[UserSearchResult]:
    return await SocialService(db).search_users(user, query, limit=limit)


@router.post("/friends/request", response_model=FriendshipRead, status_code=201)
async def request_friend(
    data: FriendRequestCreate, user: CurrentUser, db: DbSession
) -> FriendshipRead:
    friendship = await SocialService(db).request_friend(user, data.friend_id)
    return FriendshipRead.model_validate(friendship)


@router.post("/friends/{friendship_id}/accept", response_model=FriendshipRead)
async def accept_friend(
    friendship_id: str, user: CurrentUser, db: DbSession
) -> FriendshipRead:
    friendship = await SocialService(db).accept_friend(user, friendship_id)
    return FriendshipRead.model_validate(friendship)


@router.get("/friends", response_model=list[FriendshipRead])
async def list_friends(user: CurrentUser, db: DbSession) -> list[FriendshipRead]:
    items = await SocialService(db).list_friends(user.id)
    return [FriendshipRead.model_validate(i) for i in items]


@router.get("/friends/leaderboard", response_model=list[FriendLeaderboardEntry])
async def friends_leaderboard(
    user: CurrentUser, db: DbSession
) -> list[FriendLeaderboardEntry]:
    return await SocialService(db).friends_leaderboard(user)
