from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        extra="ignore",
    )

    APP_NAME: str = "AppIray"
    APP_ENV: str = "development"
    DEBUG: bool = True
    API_V1_PREFIX: str = "/api/v1"

    SECRET_KEY: str = "dev-secret-change-me"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    REFRESH_TOKEN_EXPIRE_DAYS: int = 30
    ALGORITHM: str = "HS256"

    DATABASE_URL: str = "postgresql+asyncpg://appiray:appiray@localhost:5432/appiray"
    REDIS_URL: str = "redis://localhost:6379/0"

    STORAGE_BACKEND: str = "local"
    STORAGE_LOCAL_PATH: str = "./storage"
    S3_ENDPOINT_URL: str | None = None
    S3_ACCESS_KEY_ID: str | None = None
    S3_SECRET_ACCESS_KEY: str | None = None
    S3_BUCKET_NAME: str = "appiray"
    S3_REGION: str = "auto"
    PUBLIC_ASSET_BASE_URL: str = "http://localhost:8000/static"

    MAX_HEARTS: int = 5
    XP_PER_CORRECT_ANSWER: int = 10
    STREAK_GRACE_HOURS: int = 36

    # Hearts regeneration & economy (MVP defaults, all tunable)
    HEART_REFILL_MINUTES: int = 240  # one heart every 4h
    GEM_COST_HEART_REFILL: int = 350  # gems to fully refill hearts instantly
    GEM_COST_STREAK_FREEZE: int = 200  # gems to buy a streak freeze
    STREAK_FREEZE_DAYS: int = 1  # protection window length (days)
    DEFAULT_DAILY_XP_GOAL: int = 20
    GEMS_PER_LESSON: int = 5  # gems awarded per completed lesson
    GEMS_PER_DAILY_GOAL: int = 20  # gems awarded when daily XP goal is reached
    PRACTICE_XP_REWARD: int = 5  # XP per correct practice answer
    PRACTICE_GEMS_REWARD: int = 1  # gems per correct practice answer

    # Auth tokens (password reset / email verification)
    PASSWORD_RESET_TOKEN_EXPIRE_MINUTES: int = 30
    EMAIL_VERIFICATION_TOKEN_EXPIRE_MINUTES: int = 1440
    PUBLIC_APP_URL: str = "http://localhost:8000"

    # Pluggable side-effect backends: "log" (default) or a real provider later
    EMAIL_SENDER_BACKEND: str = "log"
    PUSH_SENDER_BACKEND: str = "log"

    RATE_LIMIT_AUTH_PER_MINUTE: int = 10

    BOOTSTRAP_ADMIN_EMAIL: str | None = None
    BOOTSTRAP_ADMIN_PASSWORD: str | None = None
    BOOTSTRAP_ADMIN_USERNAME: str = "admin"


@lru_cache
def get_settings() -> Settings:
    return Settings()
