from datetime import UTC, datetime

from fastapi import HTTPException
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.modules.notifications.models import DeviceToken, Notification
from app.modules.notifications.schemas import DeviceTokenCreate
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

    async def register_device_token(self, user: User, data: DeviceTokenCreate) -> DeviceToken:
        """Register or refresh a device token (idempotent on the token value)."""
        result = await self.db.execute(select(DeviceToken).where(DeviceToken.token == data.token))
        device = result.scalar_one_or_none()
        now = datetime.now(UTC)
        if device is None:
            device = DeviceToken(
                user_id=user.id,
                token=data.token,
                platform=data.platform,
                last_seen_at=now,
            )
            self.db.add(device)
        else:
            device.user_id = user.id
            device.platform = data.platform
            device.last_seen_at = now
        await self.db.commit()
        await self.db.refresh(device)
        return device

    async def remove_device_token(self, user: User, token: str) -> None:
        result = await self.db.execute(
            select(DeviceToken).where(DeviceToken.token == token, DeviceToken.user_id == user.id)
        )
        device = result.scalar_one_or_none()
        if device is not None:
            await self.db.delete(device)
            await self.db.commit()

    async def tokens_for_user(self, user_id: str) -> list[str]:
        result = await self.db.execute(
            select(DeviceToken.token).where(DeviceToken.user_id == user_id)
        )
        return list(result.scalars().all())
