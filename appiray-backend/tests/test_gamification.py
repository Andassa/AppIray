import pytest
from app.core.enums import UserRole
from app.core.security import hash_password
from app.modules.users.models import User
from httpx import AsyncClient
from sqlalchemy.ext.asyncio import AsyncSession


@pytest.mark.asyncio
async def test_league_leaderboard(client: AsyncClient, db_session: AsyncSession) -> None:
    users = [
        User(
            email=f"u{i}@example.com",
            username=f"user{i}",
            hashed_password=hash_password("securepass1"),
            role=UserRole.USER,
            hearts=5,
            xp_total=0,
        )
        for i in range(2)
    ]
    db_session.add_all(users)
    await db_session.commit()

    tokens = []
    for i in range(2):
        login = await client.post(
            "/api/v1/auth/login",
            json={"email": f"u{i}@example.com", "password": "securepass1"},
        )
        assert login.status_code == 200
        tokens.append(login.json()["access_token"])

    # Join league
    me = await client.get(
        "/api/v1/gamification/league/me",
        headers={"Authorization": f"Bearer {tokens[0]}"},
    )
    assert me.status_code == 200, me.text

    # Simulate XP via progress service path is heavy; hit leaderboard after ensure
    lb = await client.get(
        "/api/v1/gamification/league/leaderboard",
        headers={"Authorization": f"Bearer {tokens[0]}"},
    )
    assert lb.status_code == 200, lb.text
    assert isinstance(lb.json(), list)
    assert any(entry["username"] == "user0" for entry in lb.json())
