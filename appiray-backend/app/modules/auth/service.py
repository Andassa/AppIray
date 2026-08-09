import logging
from datetime import UTC, datetime, timedelta

import jwt
from fastapi import HTTPException, status
from redis.asyncio import Redis
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.config import get_settings
from app.core.email import EmailSender, get_email_sender
from app.core.enums import UserRole
from app.core.security import (
    create_access_token,
    create_refresh_token,
    decode_token,
    generate_url_token,
    hash_password,
    hash_token,
    verify_password,
)
from app.modules.auth.models import EmailVerificationToken, PasswordResetToken
from app.modules.auth.schemas import LoginRequest, RegisterRequest, TokenResponse
from app.modules.users.models import User

logger = logging.getLogger(__name__)


class AuthService:
    def __init__(
        self,
        db: AsyncSession,
        redis: Redis,
        email_sender: EmailSender | None = None,
    ) -> None:
        self.db = db
        self.redis = redis
        self.settings = get_settings()
        self.email_sender = email_sender or get_email_sender()

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
            ttl = int(timedelta(days=self.settings.REFRESH_TOKEN_EXPIRE_DAYS).total_seconds())
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

    async def forgot_password(self, email: str) -> None:
        """Issue a password reset token. Always succeeds silently to avoid
        leaking which emails exist. Emits the reset link via EmailSender
        (logged by default until a real provider is configured)."""
        result = await self.db.execute(select(User).where(User.email == email.lower()))
        user = result.scalar_one_or_none()
        if user is None:
            return

        raw_token = generate_url_token()
        self.db.add(
            PasswordResetToken(
                user_id=user.id,
                token_hash=hash_token(raw_token),
                expires_at=datetime.now(UTC)
                + timedelta(minutes=self.settings.PASSWORD_RESET_TOKEN_EXPIRE_MINUTES),
            )
        )
        await self.db.commit()

        reset_link = f"{self.settings.PUBLIC_APP_URL}/reset-password?token={raw_token}"
        await self.email_sender.send(
            to=user.email,
            subject="AppIray — Réinitialisation du mot de passe",
            body=f"Pour réinitialiser votre mot de passe, ouvrez ce lien : {reset_link}",
        )

    async def reset_password(self, token: str, new_password: str) -> None:
        token_hash = hash_token(token)
        result = await self.db.execute(
            select(PasswordResetToken).where(PasswordResetToken.token_hash == token_hash)
        )
        reset_token = result.scalar_one_or_none()
        if reset_token is None or reset_token.used_at is not None:
            raise HTTPException(status_code=400, detail="Invalid or used reset token")

        expires_at = reset_token.expires_at
        if expires_at.tzinfo is None:
            expires_at = expires_at.replace(tzinfo=UTC)
        if expires_at < datetime.now(UTC):
            raise HTTPException(status_code=400, detail="Reset token expired")

        user = await self.db.get(User, reset_token.user_id)
        if user is None:
            raise HTTPException(status_code=404, detail="User not found")

        user.hashed_password = hash_password(new_password)
        reset_token.used_at = datetime.now(UTC)
        await self.db.commit()

    async def request_email_verification(self, user: User) -> None:
        if user.is_email_verified:
            return
        raw_token = generate_url_token()
        self.db.add(
            EmailVerificationToken(
                user_id=user.id,
                token_hash=hash_token(raw_token),
                expires_at=datetime.now(UTC)
                + timedelta(minutes=self.settings.EMAIL_VERIFICATION_TOKEN_EXPIRE_MINUTES),
            )
        )
        await self.db.commit()

        verify_link = f"{self.settings.PUBLIC_APP_URL}/verify-email?token={raw_token}"
        await self.email_sender.send(
            to=user.email,
            subject="AppIray — Vérification de l'adresse email",
            body=f"Pour vérifier votre adresse email, ouvrez ce lien : {verify_link}",
        )

    async def confirm_email_verification(self, token: str) -> None:
        token_hash = hash_token(token)
        result = await self.db.execute(
            select(EmailVerificationToken).where(EmailVerificationToken.token_hash == token_hash)
        )
        verif_token = result.scalar_one_or_none()
        if verif_token is None or verif_token.verified_at is not None:
            raise HTTPException(status_code=400, detail="Invalid or used verification token")

        expires_at = verif_token.expires_at
        if expires_at.tzinfo is None:
            expires_at = expires_at.replace(tzinfo=UTC)
        if expires_at < datetime.now(UTC):
            raise HTTPException(status_code=400, detail="Verification token expired")

        user = await self.db.get(User, verif_token.user_id)
        if user is None:
            raise HTTPException(status_code=404, detail="User not found")

        user.is_email_verified = True
        verif_token.verified_at = datetime.now(UTC)
        await self.db.commit()

    def _tokens_for(self, user: User) -> TokenResponse:
        return TokenResponse(
            access_token=create_access_token(user.id, user.role.value),
            refresh_token=create_refresh_token(user.id),
        )
