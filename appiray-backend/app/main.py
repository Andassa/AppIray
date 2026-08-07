from contextlib import asynccontextmanager
from pathlib import Path

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from sqlalchemy import select

from app.core.config import get_settings
from app.core.database import AsyncSessionLocal
from app.core.enums import UserRole
from app.core.redis import close_redis
from app.core.security import hash_password
from app.modules.audio.router import router as audio_router
from app.modules.auth.router import router as auth_router
from app.modules.content.router import router as content_router
from app.modules.courses.router import router as courses_router
from app.modules.gamification.router import router as gamification_router
from app.modules.notifications.router import router as notifications_router
from app.modules.progress.router import router as progress_router
from app.modules.social.router import router as social_router
from app.modules.users.models import User
from app.modules.users.router import router as users_router
from app.workers.jobs import register_scheduled_jobs
from app.workers.queue import get_task_queue


async def bootstrap_admin() -> None:
    settings = get_settings()
    if not settings.BOOTSTRAP_ADMIN_EMAIL or not settings.BOOTSTRAP_ADMIN_PASSWORD:
        return
    async with AsyncSessionLocal() as session:
        result = await session.execute(
            select(User).where(User.email == settings.BOOTSTRAP_ADMIN_EMAIL.lower())
        )
        if result.scalar_one_or_none():
            return
        session.add(
            User(
                email=settings.BOOTSTRAP_ADMIN_EMAIL.lower(),
                username=settings.BOOTSTRAP_ADMIN_USERNAME,
                hashed_password=hash_password(settings.BOOTSTRAP_ADMIN_PASSWORD),
                role=UserRole.ADMIN,
                hearts=settings.MAX_HEARTS,
            )
        )
        await session.commit()


@asynccontextmanager
async def lifespan(_: FastAPI):
    settings = get_settings()
    Path(settings.STORAGE_LOCAL_PATH).mkdir(parents=True, exist_ok=True)
    await bootstrap_admin()
    await register_scheduled_jobs()
    yield
    get_task_queue().shutdown()
    await close_redis()


def create_app(*, with_lifespan: bool = True) -> FastAPI:
    settings = get_settings()
    app = FastAPI(
        title=settings.APP_NAME,
        version="0.1.0",
        description="AppIray — Duolingo-like Malagasy learning backend (modular monolith)",
        lifespan=lifespan if with_lifespan else None,
    )
    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    storage_path = Path(settings.STORAGE_LOCAL_PATH)
    storage_path.mkdir(parents=True, exist_ok=True)
    app.mount("/static", StaticFiles(directory=str(storage_path)), name="static")

    prefix = settings.API_V1_PREFIX
    app.include_router(auth_router, prefix=prefix)
    app.include_router(users_router, prefix=prefix)
    app.include_router(courses_router, prefix=prefix)
    app.include_router(progress_router, prefix=prefix)
    app.include_router(gamification_router, prefix=prefix)
    app.include_router(social_router, prefix=prefix)
    app.include_router(content_router, prefix=prefix)
    app.include_router(audio_router, prefix=prefix)
    app.include_router(notifications_router, prefix=prefix)

    @app.get("/health")
    async def health() -> dict:
        return {"status": "ok", "app": settings.APP_NAME}

    return app


app = create_app()
