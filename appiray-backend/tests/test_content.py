import pytest
from httpx import AsyncClient
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.enums import UserRole
from tests.helpers import auth, create_user, login


async def _admin_and_user(db: AsyncSession) -> None:
    await create_user(
        db, email="admin@example.com", username="admin", role=UserRole.ADMIN
    )
    await create_user(db, email="member@example.com", username="member")


@pytest.mark.asyncio
async def test_publication_draft_publish_workflow(
    client: AsyncClient, db_session: AsyncSession
) -> None:
    await _admin_and_user(db_session)
    admin_token = await login(client, email="admin@example.com")
    user_token = await login(client, email="member@example.com")

    created = await client.post(
        "/api/v1/content/publications",
        headers=auth(admin_token),
        json={
            "title": "Histoire de Mada",
            "body": "corps",
            "category": "histoire",
            "author": "Rakoto",
        },
    )
    assert created.status_code == 201, created.text
    pub_id = created.json()["id"]
    assert created.json()["status"] == "draft"

    # Draft is not visible in the public listing/detail.
    public_list = await client.get("/api/v1/content/publications")
    assert all(p["id"] != pub_id for p in public_list.json()["items"])
    public_detail = await client.get(f"/api/v1/content/publications/{pub_id}")
    assert public_detail.status_code == 404

    # Admin can see drafts in the admin listing.
    admin_list = await client.get(
        "/api/v1/content/admin/publications",
        headers=auth(admin_token),
        params={"status": "draft"},
    )
    assert any(p["id"] == pub_id for p in admin_list.json()["items"])

    # Non-admin cannot publish.
    forbidden = await client.post(
        f"/api/v1/content/publications/{pub_id}/publish", headers=auth(user_token)
    )
    assert forbidden.status_code == 403

    # Admin publishes → now public.
    published = await client.post(
        f"/api/v1/content/publications/{pub_id}/publish", headers=auth(admin_token)
    )
    assert published.status_code == 200
    assert published.json()["status"] == "published"

    public_detail2 = await client.get(f"/api/v1/content/publications/{pub_id}")
    assert public_detail2.status_code == 200


@pytest.mark.asyncio
async def test_like_and_comment_moderation(
    client: AsyncClient, db_session: AsyncSession
) -> None:
    await _admin_and_user(db_session)
    admin_token = await login(client, email="admin@example.com")
    user_token = await login(client, email="member@example.com")

    created = await client.post(
        "/api/v1/content/publications",
        headers=auth(admin_token),
        json={"title": "T", "body": "b", "category": "culture", "author": "A"},
    )
    pub_id = created.json()["id"]
    await client.post(
        f"/api/v1/content/publications/{pub_id}/publish", headers=auth(admin_token)
    )

    like = await client.post(
        f"/api/v1/content/publications/{pub_id}/like", headers=auth(user_token)
    )
    assert like.status_code == 204

    comment = await client.post(
        f"/api/v1/content/publications/{pub_id}/comments",
        headers=auth(user_token),
        json={"body": "Super article"},
    )
    assert comment.status_code == 201
    comment_id = comment.json()["id"]

    # Another regular user cannot delete someone else's comment.
    await create_user(db_session, email="intru@example.com", username="intruder")
    intruder_token = await login(client, email="intru@example.com")
    forbidden = await client.request(
        "DELETE",
        f"/api/v1/content/publications/{pub_id}/comments/{comment_id}",
        headers=auth(intruder_token),
    )
    assert forbidden.status_code == 403

    # The author can delete their own comment.
    deleted = await client.request(
        "DELETE",
        f"/api/v1/content/publications/{pub_id}/comments/{comment_id}",
        headers=auth(user_token),
    )
    assert deleted.status_code == 204
