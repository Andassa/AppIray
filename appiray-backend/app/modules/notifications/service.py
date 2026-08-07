from datetime import UTC, datetime

from fastapi import HTTPException
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.modules.notifications.models import Notification
from app.modules.users.models import User


class NotificationService:
    def __init__(self, db: AsyncSession) -> None:
        self.db = db

    async def list_for_user(self, user_id: str, unread_only: bool = False) -> list[Notification]:
        query = (
            select(Notification)
            .where(Notification.user_id == user_id)
            .order_by(Notification.created_at.desc())
        )
        if unread_only:
            query = query.where(Notification.read_at.is_(None))
        result = await self.db.execute(query)
        return list(result.scalars().all())

    async def mark_read(self, user: User, notification_id: str) -> Notification:
        notification = await self.db.get(Notification, notification_id)
        if notification is None or notification.user_id != user.id:
            raise HTTPException(status_code=404, detail="Notification not found")
        notification.read_at = datetime.now(UTC)
        await self.db.commit()
        await self.db.refresh(notification)
        return notification

    async def mark_all_read(self, user: User) -> int:
        items = await self.list_for_user(user.id, unread_only=True)
        now = datetime.now(UTC)
        for item in items:
            item.read_at = now
        await self.db.commit()
        return len(items)
