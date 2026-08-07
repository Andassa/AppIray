from datetime import UTC, datetime, timedelta

import jwt
from fastapi import HTTPException, status
from redis.asyncio import Redis
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.config import get_settings
from app.core.enums import UserRole
from app.core.security import (
    create_access_token,
    create_refresh_token,
    decode_token,
    hash_password,
    verify_password,
)
from app.modules.auth.schemas import LoginRequest, RegisterRequest, TokenResponse
from app.modules.users.models import User


class AuthService:
    def __init__(self, db: AsyncSession, redis: Redis) -> None:
        self.db = db
        self.redis = redis
        self.settings = get_settings()

    async def register(self, data: RegisterRequest) -> TokenResponse:
        existing = await self.db.execute(
            select(User).where((User.email == data.email) | (User.username == data.username))
        )
        if existing.scalar_one_or_none():
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="Email or username already registered",
            )

        user = User(
            email=data.email.lower(),
            username=data.username,
            hashed_password=hash_password(data.password),
            role=UserRole.USER,
            hearts=self.settings.MAX_HEARTS,
            last_active_at=datetime.now(UTC),
        )
        self.db.add(user)
        await self.db.flush()
        await self.db.commit()
        await self.db.refresh(user)
        return self._tokens_for(user)

    async def login(self, data: LoginRequest) -> TokenResponse:
        result = await self.db.execute(select(User).where(User.email == data.email.lower()))
        user = result.scalar_one_or_none()
        if user is None or not verify_password(data.password, user.hashed_password):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid credentials",
            )
        user.last_active_at = datetime.now(UTC)
        await self.db.commit()
        return self._tokens_for(user)

    async def refresh(self, refresh_token: str) -> TokenResponse:
        try:
            payload = decode_token(refresh_token)
        except jwt.PyJWTError as exc:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid refresh token",
            ) from exc

        if payload.get("type") != "refresh":
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid token type",
            )

        jti = payload.get("jti")
        if jti and await self.redis.get(f"blacklist:{jti}"):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Refresh token revoked",
            )

        result = await self.db.execute(select(User).where(User.id == payload.get("sub")))
        user = result.scalar_one_or_none()
        if user is None:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="User not found",
            )

        # Rotate: blacklist old refresh token
        if jti:
            ttl = int(
                timedelta(days=self.settings.REFRESH_TOKEN_EXPIRE_DAYS).total_seconds()
            )
            await self.redis.setex(f"blacklist:{jti}", ttl, "1")

        return self._tokens_for(user)

    async def logout(self, access_token: str, refresh_token: str | None = None) -> None:
        await self._blacklist(access_token)
        if refresh_token:
            await self._blacklist(refresh_token)

    async def _blacklist(self, token: str) -> None:
        try:
            payload = decode_token(token)
        except jwt.PyJWTError:
            return
        jti = payload.get("jti")
        exp = payload.get("exp")
        if not jti or not exp:
            return
        ttl = max(int(exp - datetime.now(UTC).timestamp()), 1)
        await self.redis.setex(f"blacklist:{jti}", ttl, "1")

    def _tokens_for(self, user: User) -> TokenResponse:
        return TokenResponse(
            access_token=create_access_token(user.id, user.role.value),
            refresh_token=create_refresh_token(user.id),
        )
