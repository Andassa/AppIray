from typing import Annotated

from fastapi import APIRouter, Depends, Request
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer

from app.core.deps import DbSession, RedisClient
from app.core.rate_limit import enforce_rate_limit
from app.modules.auth.schemas import (
    LoginRequest,
    MessageResponse,
    RefreshRequest,
    RegisterRequest,
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
