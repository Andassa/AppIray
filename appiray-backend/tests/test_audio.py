import pytest
from httpx import AsyncClient
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.enums import UserRole
from tests.helpers import auth, create_user, login


@pytest.mark.asyncio
async def test_audio_asset_crud(client: AsyncClient, db_session: AsyncSession) -> None:
    await create_user(
        db_session, email="admin@example.com", username="admin", role=UserRole.ADMIN
    )
    token = await login(client, email="admin@example.com")

    created = await client.post(
        "/api/v1/audio/assets",
        headers=auth(token),
        json={
            "text_malagasy": "Salama",
            "audio_url": "http://cdn.example.com/salama.mp3",
        },
    )
    assert created.status_code == 201, created.text
    asset_id = created.json()["id"]

    got = await client.get(f"/api/v1/audio/assets/{asset_id}", headers=auth(token))
    assert got.status_code == 200
    assert got.json()["text_malagasy"] == "Salama"

    listing = await client.get(
        "/api/v1/audio/assets", headers=auth(token), params={"q": "Sala"}
    )
    assert listing.status_code == 200
    assert any(a["id"] == asset_id for a in listing.json())


@pytest.mark.asyncio
async def test_audio_asset_requires_admin(
    client: AsyncClient, db_session: AsyncSession
) -> None:
    await create_user(db_session, email="user@example.com", username="plainuser")
    token = await login(client, email="user@example.com")
    resp = await client.post(
        "/api/v1/audio/assets",
        headers=auth(token),
        json={"text_malagasy": "x", "audio_url": "http://x"},
    )
    assert resp.status_code == 403
