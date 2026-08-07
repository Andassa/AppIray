from fastapi import APIRouter, Query

from app.core.deps import CurrentAdmin, CurrentUser, DbSession, RedisClient
from app.modules.gamification.schemas import (
    BadgeCreate,
    BadgeRead,
    LeaderboardEntry,
    LeagueRead,
    UserBadgeRead,
)
from app.modules.gamification.service import GamificationService

router = APIRouter(prefix="/gamification", tags=["gamification"])


@router.get("/league/me", response_model=LeagueRead)
async def my_league(
    user: CurrentUser, db: DbSession, redis: RedisClient
) -> LeagueRead:
    league = await GamificationService(db, redis).current_league(user)
    await db.commit()
    return LeagueRead.model_validate(league)


@router.get("/league/leaderboard", response_model=list[LeaderboardEntry])
async def leaderboard(
    user: CurrentUser,
    db: DbSession,
    redis: RedisClient,
    limit: int = Query(default=50, ge=1, le=100),
) -> list[LeaderboardEntry]:
    return await GamificationService(db, redis).get_leaderboard(user, limit=limit)


@router.get("/badges", response_model=list[BadgeRead])
async def list_badges(db: DbSession, redis: RedisClient, _: CurrentUser) -> list[BadgeRead]:
    badges = await GamificationService(db, redis).list_badges()
    return [BadgeRead.model_validate(b) for b in badges]


@router.post("/badges", response_model=BadgeRead, status_code=201)
async def create_badge(
    data: BadgeCreate, db: DbSession, redis: RedisClient, _: CurrentAdmin
) -> BadgeRead:
    badge = await GamificationService(db, redis).create_badge(data)
    return BadgeRead.model_validate(badge)


@router.get("/badges/me", response_model=list[UserBadgeRead])
async def my_badges(
    user: CurrentUser, db: DbSession, redis: RedisClient
) -> list[UserBadgeRead]:
    items = await GamificationService(db, redis).list_user_badges(user.id)
    return [UserBadgeRead.model_validate(i) for i in items]
