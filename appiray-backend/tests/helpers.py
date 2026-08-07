from httpx import AsyncClient
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.enums import UserRole
from app.core.security import hash_password
from app.modules.users.models import User


async def register_user(
    client: AsyncClient,
    *,
    email: str = "user@example.com",
    username: str = "user1",
    password: str = "securepass1",
) -> str:
    resp = await client.post(
        "/api/v1/auth/register",
        json={"email": email, "username": username, "password": password},
    )
    assert resp.status_code == 201, resp.text
    return resp.json()["access_token"]


async def create_user(
    db: AsyncSession,
    *,
    email: str,
    username: str,
    password: str = "securepass1",
    role: UserRole = UserRole.USER,
    **kwargs,
) -> User:
    user = User(
        email=email.lower(),
        username=username,
        hashed_password=hash_password(password),
        role=role,
        hearts=kwargs.pop("hearts", 5),
        **kwargs,
    )
    db.add(user)
    await db.commit()
    await db.refresh(user)
    return user


async def login(
    client: AsyncClient, *, email: str, password: str = "securepass1"
) -> str:
    resp = await client.post(
        "/api/v1/auth/login", json={"email": email, "password": password}
    )
    assert resp.status_code == 200, resp.text
    return resp.json()["access_token"]


def auth(token: str) -> dict[str, str]:
    return {"Authorization": f"Bearer {token}"}
