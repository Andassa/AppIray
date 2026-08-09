from fastapi import APIRouter

from app.core.config import get_settings
from app.core.deps import CurrentUser, DbSession, RedisClient
from app.modules.progress.hearts import apply_heart_regen
from app.modules.progress.schemas import (
    AnswerResult,
    AnswerSubmit,
    DailyGoalUpdate,
    HeartsStatus,
    PracticeExercise,
    ProgressRead,
    StreakFreezeRead,
    XPTransactionRead,
)
from app.modules.progress.service import ProgressService

router = APIRouter(prefix="/progress", tags=["progress"])


@router.post("/answer", response_model=AnswerResult)
async def submit_answer(
    data: AnswerSubmit,
    user: CurrentUser,
    db: DbSession,
    redis: RedisClient,
) -> AnswerResult:
    return await ProgressService(db, redis).submit_answer(user, data)


@router.get("/me", response_model=list[ProgressRead])
async def my_progress(user: CurrentUser, db: DbSession, redis: RedisClient) -> list[ProgressRead]:
    service = ProgressService(db, redis)
    if apply_heart_regen(user, service.settings):
        await db.commit()
    items = await service.list_progress(user.id)
    return [ProgressRead.model_validate(i) for i in items]


@router.get("/me/xp", response_model=list[XPTransactionRead])
async def my_xp(user: CurrentUser, db: DbSession, redis: RedisClient) -> list[XPTransactionRead]:
    items = await ProgressService(db, redis).list_xp(user.id)
    return [XPTransactionRead.model_validate(i) for i in items]


@router.get("/hearts", response_model=HeartsStatus)
async def hearts_status(user: CurrentUser, db: DbSession, redis: RedisClient) -> HeartsStatus:
    settings = get_settings()
    if apply_heart_regen(user, settings):
        await db.commit()
    return HeartsStatus(
        hearts=user.hearts,
        max_hearts=settings.MAX_HEARTS,
        heart_refill_at=user.heart_refill_at,
        gems=user.gems,
    )


@router.post("/hearts/refill-with-gems", response_model=HeartsStatus)
async def refill_hearts_with_gems(
    user: CurrentUser, db: DbSession, redis: RedisClient
) -> HeartsStatus:
    settings = get_settings()
    updated = await ProgressService(db, redis).refill_hearts_with_gems(user)
    return HeartsStatus(
        hearts=updated.hearts,
        max_hearts=settings.MAX_HEARTS,
        heart_refill_at=updated.heart_refill_at,
        gems=updated.gems,
    )


@router.post("/streak/freeze", response_model=StreakFreezeRead, status_code=201)
async def buy_streak_freeze(
    user: CurrentUser, db: DbSession, redis: RedisClient
) -> StreakFreezeRead:
    freeze = await ProgressService(db, redis).buy_streak_freeze(user)
    return StreakFreezeRead.model_validate(freeze)


@router.patch("/daily-goal")
async def update_daily_goal(
    data: DailyGoalUpdate,
    user: CurrentUser,
    db: DbSession,
    redis: RedisClient,
) -> dict:
    updated = await ProgressService(db, redis).update_daily_goal(user, data.daily_xp_goal)
    return {"daily_xp_goal": updated.daily_xp_goal}


@router.get("/practice", response_model=list[PracticeExercise])
async def practice_session(
    user: CurrentUser, db: DbSession, redis: RedisClient
) -> list[PracticeExercise]:
    exercises = await ProgressService(db, redis).select_practice_exercises(user.id)
    return [
        PracticeExercise(
            id=e.id,
            lesson_id=e.lesson_id,
            type=e.type.value,
            content=e.content,
            audio_asset_id=e.audio_asset_id,
        )
        for e in exercises
    ]
