import pytest
from httpx import AsyncClient


@pytest.mark.asyncio
async def test_register_and_login(client: AsyncClient) -> None:
    register = await client.post(
        "/api/v1/auth/register",
        json={
            "email": "learner@example.com",
            "username": "learner1",
            "password": "securepass1",
        },
    )
    assert register.status_code == 201, register.text
    body = register.json()
    assert "access_token" in body
    assert "refresh_token" in body

    login = await client.post(
        "/api/v1/auth/login",
        json={"email": "learner@example.com", "password": "securepass1"},
    )
    assert login.status_code == 200, login.text
    assert login.json()["access_token"]

    me = await client.get(
        "/api/v1/users/me",
        headers={"Authorization": f"Bearer {login.json()['access_token']}"},
    )
    assert me.status_code == 200
    assert me.json()["username"] == "learner1"
    assert me.json()["email"] == "learner@example.com"
