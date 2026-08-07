from collections.abc import AsyncGenerator
from typing import Any

import pytest_asyncio
from httpx import ASGITransport, AsyncClient
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine

from app.core.database import Base, get_db
from app.core.redis import get_redis
from app.main import create_app
import app.models  # noqa: F401


class FakeRedis:
    def __init__(self) -> None:
        self._store: dict[str, Any] = {}
        self._zsets: dict[str, dict[str, float]] = {}
        self._ttl: dict[str, int] = {}

    async def incr(self, key: str) -> int:
        self._store[key] = int(self._store.get(key, 0)) + 1
        return int(self._store[key])

    async def expire(self, key: str, seconds: int) -> bool:
        self._ttl[key] = seconds
        return True

    async def get(self, key: str) -> str | None:
        value = self._store.get(key)
        return None if value is None else str(value)

    async def setex(self, key: str, seconds: int, value: str) -> bool:
        self._store[key] = value
        self._ttl[key] = seconds
        return True

    async def zadd(self, key: str, mapping: dict[str, float]) -> int:
        z = self._zsets.setdefault(key, {})
        z.update({str(k): float(v) for k, v in mapping.items()})
        return len(mapping)

    async def zincrby(self, key: str, amount: float, member: str) -> float:
        z = self._zsets.setdefault(key, {})
        z[member] = z.get(member, 0.0) + float(amount)
        return z[member]

    async def zrevrange(
        self, key: str, start: int, end: int, withscores: bool = False
    ):
        z = self._zsets.get(key, {})
        ordered = sorted(z.items(), key=lambda x: x[1], reverse=True)
        if end == -1:
            slice_ = ordered[start:]
        else:
            slice_ = ordered[start : end + 1]
        if withscores:
            return slice_
        return [m for m, _ in slice_]

    async def delete(self, key: str) -> int:
        existed = key in self._store or key in self._zsets
        self._store.pop(key, None)
        self._zsets.pop(key, None)
        return 1 if existed else 0

    async def aclose(self) -> None:
        return None


@pytest_asyncio.fixture
async def db_session() -> AsyncGenerator[AsyncSession, None]:
    engine = create_async_engine("sqlite+aiosqlite:///:memory:", echo=False)
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

    session_factory = async_sessionmaker(engine, expire_on_commit=False)
    async with session_factory() as session:
        yield session

    await engine.dispose()


@pytest_asyncio.fixture
async def client(db_session: AsyncSession) -> AsyncGenerator[AsyncClient, None]:
    app = create_app(with_lifespan=False)
    fake_redis = FakeRedis()

    async def override_db():
        yield db_session

    async def override_redis():
        return fake_redis

    app.dependency_overrides[get_db] = override_db
    app.dependency_overrides[get_redis] = override_redis

    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as ac:
        yield ac

    app.dependency_overrides.clear()
