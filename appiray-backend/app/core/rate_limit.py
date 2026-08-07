from fastapi import HTTPException, Request, status
from redis.asyncio import Redis

from app.core.config import get_settings


async def enforce_rate_limit(
    request: Request,
    redis: Redis,
    *,
    key_prefix: str,
    limit: int | None = None,
    window_seconds: int = 60,
) -> None:
    settings = get_settings()
    max_requests = limit if limit is not None else settings.RATE_LIMIT_AUTH_PER_MINUTE
    client_ip = request.client.host if request.client else "unknown"
    key = f"rl:{key_prefix}:{client_ip}"
    current = await redis.incr(key)
    if current == 1:
        await redis.expire(key, window_seconds)
    if current > max_requests:
        raise HTTPException(
            status_code=status.HTTP_429_TOO_MANY_REQUESTS,
            detail="Rate limit exceeded. Try again later.",
        )
