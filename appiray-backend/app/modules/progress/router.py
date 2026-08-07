from fastapi import APIRouter

from app.core.deps import CurrentUser, DbSession, RedisClient
from app.modules.progress.schemas import (
    AnswerResult,
    AnswerSubmit,
    ProgressRead,
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
    items = await ProgressService(db, redis).list_progress(user.id)
    return [ProgressRead.model_validate(i) for i in items]


@router.get("/me/xp", response_model=list[XPTransactionRead])
async def my_xp(
    user: CurrentUser, db: DbSession, redis: RedisClient
) -> list[XPTransactionRead]:
    items = await ProgressService(db, redis).list_xp(user.id)
    return [XPTransactionRead.model_validate(i) for i in items]
