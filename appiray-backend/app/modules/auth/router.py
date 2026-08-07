from typing import Annotated

from fastapi import APIRouter, Depends, Request
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer

from app.core.deps import CurrentUser, DbSession, Email, RedisClient
from app.core.rate_limit import enforce_rate_limit
from app.modules.auth.schemas import (
    EmailVerificationConfirm,
    EmailVerificationRequest,
    ForgotPasswordRequest,
    LoginRequest,
    MessageResponse,
    RefreshRequest,
    RegisterRequest,
    ResetPasswordRequest,
    TokenResponse,
)
from app.modules.auth.service import AuthService

router = APIRouter(prefix="/auth", tags=["auth"])
bearer = HTTPBearer(auto_error=False)


@router.post("/register", response_model=TokenResponse, status_code=201)
async def register(
    request: Request,
    data: RegisterRequest,
    db: DbSession,
    redis: RedisClient,
) -> TokenResponse:
    await enforce_rate_limit(request, redis, key_prefix="auth_register")
    return await AuthService(db, redis).register(data)


@router.post("/login", response_model=TokenResponse)
async def login(
    request: Request,
    data: LoginRequest,
    db: DbSession,
    redis: RedisClient,
) -> TokenResponse:
    await enforce_rate_limit(request, redis, key_prefix="auth_login")
    return await AuthService(db, redis).login(data)


@router.post("/refresh", response_model=TokenResponse)
async def refresh(
    request: Request,
    data: RefreshRequest,
    db: DbSession,
    redis: RedisClient,
) -> TokenResponse:
    await enforce_rate_limit(request, redis, key_prefix="auth_refresh")
    return await AuthService(db, redis).refresh(data.refresh_token)


@router.post("/logout", response_model=MessageResponse)
async def logout(
    data: RefreshRequest,
    db: DbSession,
    redis: RedisClient,
    credentials: Annotated[HTTPAuthorizationCredentials | None, Depends(bearer)],
) -> MessageResponse:
    access = credentials.credentials if credentials else ""
    await AuthService(db, redis).logout(access, data.refresh_token)
    return MessageResponse(detail="Logged out")


@router.post("/forgot-password", response_model=MessageResponse)
async def forgot_password(
    request: Request,
    data: ForgotPasswordRequest,
    db: DbSession,
    redis: RedisClient,
    email_sender: Email,
) -> MessageResponse:
    await enforce_rate_limit(request, redis, key_prefix="auth_forgot_password")
    await AuthService(db, redis, email_sender).forgot_password(data.email)
    return MessageResponse(detail="If the email exists, a reset link has been sent")


@router.post("/reset-password", response_model=MessageResponse)
async def reset_password(
    request: Request,
    data: ResetPasswordRequest,
    db: DbSession,
    redis: RedisClient,
) -> MessageResponse:
    await enforce_rate_limit(request, redis, key_prefix="auth_reset_password")
    await AuthService(db, redis).reset_password(data.token, data.new_password)
    return MessageResponse(detail="Password updated")


@router.post("/verify-email/request", response_model=MessageResponse)
async def request_email_verification(
    request: Request,
    user: CurrentUser,
    db: DbSession,
    redis: RedisClient,
    email_sender: Email,
    _data: EmailVerificationRequest | None = None,
) -> MessageResponse:
    await enforce_rate_limit(request, redis, key_prefix="auth_verify_email_request")
    await AuthService(db, redis, email_sender).request_email_verification(user)
    return MessageResponse(detail="Verification email sent if not already verified")


@router.post("/verify-email/confirm", response_model=MessageResponse)
async def confirm_email_verification(
    data: EmailVerificationConfirm,
    db: DbSession,
    redis: RedisClient,
) -> MessageResponse:
    await AuthService(db, redis).confirm_email_verification(data.token)
    return MessageResponse(detail="Email verified")
