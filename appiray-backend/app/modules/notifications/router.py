from fastapi import APIRouter, Query

from app.core.deps import CurrentUser, DbSession
from app.modules.notifications.schemas import NotificationRead
from app.modules.notifications.service import NotificationService

router = APIRouter(prefix="/notifications", tags=["notifications"])


@router.get("", response_model=list[NotificationRead])
async def list_notifications(
    user: CurrentUser,
    db: DbSession,
    unread_only: bool = Query(default=False),
) -> list[NotificationRead]:
    items = await NotificationService(db).list_for_user(user.id, unread_only=unread_only)
    return [NotificationRead.model_validate(i) for i in items]


@router.post("/{notification_id}/read", response_model=NotificationRead)
async def mark_read(
    notification_id: str, user: CurrentUser, db: DbSession
) -> NotificationRead:
    item = await NotificationService(db).mark_read(user, notification_id)
    return NotificationRead.model_validate(item)


@router.post("/read-all")
async def mark_all_read(user: CurrentUser, db: DbSession) -> dict:
    count = await NotificationService(db).mark_all_read(user)
    return {"marked": count}
