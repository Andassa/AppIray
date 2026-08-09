import pytest
from app.core.enums import UserRole
from httpx import AsyncClient
from sqlalchemy.ext.asyncio import AsyncSession

from tests.helpers import auth, create_user, login


async def _admin_token(client: AsyncClient, db_session: AsyncSession) -> str:
    await create_user(
        db_session, email="admin@example.com", username="admin", role=UserRole.ADMIN
    )
    return await login(client, email="admin@example.com")


@pytest.mark.asyncio
async def test_audio_asset_crud(client: AsyncClient, db_session: AsyncSession) -> None:
    token = await _admin_token(client, db_session)

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
        "/api/v1/audio/assets",
        headers=auth(token),
        params={"text_malagasy": "Sala"},
    )
    assert listing.status_code == 200
    body = listing.json()
    assert "items" in body and "total" in body
    assert any(a["id"] == asset_id for a in body["items"])


@pytest.mark.asyncio
async def test_audio_asset_requires_admin(client: AsyncClient, db_session: AsyncSession) -> None:
    await create_user(db_session, email="user@example.com", username="plainuser")
    token = await login(client, email="user@example.com")
    resp = await client.post(
        "/api/v1/audio/assets",
        headers=auth(token),
        json={"text_malagasy": "x", "audio_url": "http://x"},
    )
    assert resp.status_code == 403


@pytest.mark.asyncio
async def test_audio_assets_pagination(client: AsyncClient, db_session: AsyncSession) -> None:
    token = await _admin_token(client, db_session)
    headers = auth(token)

    for i in range(5):
        resp = await client.post(
            "/api/v1/audio/assets",
            headers=headers,
            json={
                "text_malagasy": f"phrase-{i}",
                "audio_url": f"http://cdn.example.com/{i}.mp3",
                "voice_model_version": "mms-base-v1",
            },
        )
        assert resp.status_code == 201, resp.text

    page1 = await client.get(
        "/api/v1/audio/assets",
        headers=headers,
        params={"page": 1, "page_size": 2},
    )
    assert page1.status_code == 200
    body1 = page1.json()
    assert body1["page"] == 1
    assert body1["page_size"] == 2
    assert body1["total"] == 5
    assert len(body1["items"]) == 2

    page2 = await client.get(
        "/api/v1/audio/assets",
        headers=headers,
        params={"page": 2, "page_size": 2},
    )
    assert page2.status_code == 200
    body2 = page2.json()
    assert body2["page"] == 2
    assert len(body2["items"]) == 2
    ids1 = {a["id"] for a in body1["items"]}
    ids2 = {a["id"] for a in body2["items"]}
    assert ids1.isdisjoint(ids2)


@pytest.mark.asyncio
async def test_audio_assets_filter_voice_model(
    client: AsyncClient, db_session: AsyncSession
) -> None:
    token = await _admin_token(client, db_session)
    headers = auth(token)

    await client.post(
        "/api/v1/audio/assets",
        headers=headers,
        json={
            "text_malagasy": "A",
            "audio_url": "http://cdn.example.com/a.mp3",
            "voice_model_version": "voice-a",
        },
    )
    await client.post(
        "/api/v1/audio/assets",
        headers=headers,
        json={
            "text_malagasy": "B",
            "audio_url": "http://cdn.example.com/b.mp3",
            "voice_model_version": "voice-b",
        },
    )

    resp = await client.get(
        "/api/v1/audio/assets",
        headers=headers,
        params={"voice_model_version": "voice-a"},
    )
    assert resp.status_code == 200
    body = resp.json()
    assert body["total"] == 1
    assert body["items"][0]["voice_model_version"] == "voice-a"
    assert body["items"][0]["text_malagasy"] == "A"


@pytest.mark.asyncio
async def test_audio_assets_filter_text_malagasy(
    client: AsyncClient, db_session: AsyncSession
) -> None:
    token = await _admin_token(client, db_session)
    headers = auth(token)

    await client.post(
        "/api/v1/audio/assets",
        headers=headers,
        json={
            "text_malagasy": "Manahoana",
            "audio_url": "http://cdn.example.com/m.mp3",
        },
    )
    await client.post(
        "/api/v1/audio/assets",
        headers=headers,
        json={
            "text_malagasy": "Veloma",
            "audio_url": "http://cdn.example.com/v.mp3",
        },
    )

    resp = await client.get(
        "/api/v1/audio/assets",
        headers=headers,
        params={"text_malagasy": "manaho"},
    )
    assert resp.status_code == 200
    body = resp.json()
    assert body["total"] == 1
    assert body["items"][0]["text_malagasy"] == "Manahoana"
