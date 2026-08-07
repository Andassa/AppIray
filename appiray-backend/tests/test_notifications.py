import pytest
from httpx import AsyncClient
from sqlalchemy.ext.asyncio import AsyncSession

from tests.helpers import auth, create_user, login


@pytest.mark.asyncio
async def test_device_token_register_and_remove(
    client: AsyncClient, db_session: AsyncSession
) -> None:
    await create_user(db_session, email="dev@example.com", username="devuser")
    token = await login(client, email="dev@example.com")

    reg = await client.post(
        "/api/v1/notifications/device-token",
        headers=auth(token),
        json={"token": "fcm-abc-123", "platform": "android"},
    )
    assert reg.status_code == 201, reg.text
    assert reg.json()["platform"] == "android"

    # Re-registering the same token is idempotent (no duplicate / no error).
    reg2 = await client.post(
        "/api/v1/notifications/device-token",
        headers=auth(token),
        json={"token": "fcm-abc-123", "platform": "ios"},
    )
    assert reg2.status_code == 201
    assert reg2.json()["platform"] == "ios"

    removed = await client.request(
        "DELETE",
        "/api/v1/notifications/device-token",
        headers=auth(token),
        json={"token": "fcm-abc-123", "platform": "ios"},
    )
    assert removed.status_code == 204


@pytest.mark.asyncio
async def test_notifications_listing(
    client: AsyncClient, db_session: AsyncSession
) -> None:
    await create_user(db_session, email="notif@example.com", username="notifier")
    token = await login(client, email="notif@example.com")

    listing = await client.get("/api/v1/notifications", headers=auth(token))
    assert listing.status_code == 200
    assert isinstance(listing.json(), list)

    read_all = await client.post("/api/v1/notifications/read-all", headers=auth(token))
    assert read_all.status_code == 200
    assert "marked" in read_all.json()
