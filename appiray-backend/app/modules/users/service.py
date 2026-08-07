from fastapi import HTTPException, UploadFile, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.storage import StorageBackend
from app.modules.users.models import User
from app.modules.users.schemas import UserUpdate


class UserService:
    def __init__(self, db: AsyncSession, storage: StorageBackend) -> None:
        self.db = db
        self.storage = storage

    async def get_by_id(self, user_id: str) -> User:
        result = await self.db.execute(select(User).where(User.id == user_id))
        user = result.scalar_one_or_none()
        if user is None:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
        return user

    async def update_profile(self, user: User, data: UserUpdate) -> User:
        if data.username and data.username != user.username:
            exists = await self.db.execute(select(User).where(User.username == data.username))
            if exists.scalar_one_or_none():
                raise HTTPException(
                    status_code=status.HTTP_409_CONFLICT,
                    detail="Username already taken",
                )
            user.username = data.username
        await self.db.commit()
        await self.db.refresh(user)
        return user

    async def upload_avatar(self, user: User, file: UploadFile) -> User:
        content = await file.read()
        if len(content) > 5 * 1024 * 1024:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Avatar must be <= 5MB",
            )
        url = await self.storage.upload(
            content,
            content_type=file.content_type,
            folder="avatars",
        )
        user.avatar_url = url
        await self.db.commit()
        await self.db.refresh(user)
        return user
