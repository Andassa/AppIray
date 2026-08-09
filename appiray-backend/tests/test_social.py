import pytest
from httpx import AsyncClient
from sqlalchemy.ext.asyncio import AsyncSession

from tests.helpers import auth, create_user, login


@pytest.mark.asyncio
async def test_user_search_and_relationship(client: AsyncClient, db_session: AsyncSession) -> None:
    await create_user(db_session, email="searcher@example.com", username="searcher")
    await create_user(db_session, email="target@example.com", username="targetuser")
    await create_user(db_session, email="other@example.com", username="another")
    token = await login(client, email="searcher@example.com")

    # Search excludes the current user and matches partial, case-insensitively.
    res = await client.get(
        "/api/v1/social/users/search", headers=auth(token), params={"query": "TARGET"}
    )
    assert res.status_code == 200
    results = res.json()
    assert len(results) == 1
    assert results[0]["username"] == "targetuser"
    assert results[0]["friendship_status"] == "none"

    # After a friend request, the status is reflected in search.
    target_id = results[0]["user_id"]
    await client.post(
        "/api/v1/social/friends/request",
        headers=auth(token),
        json={"friend_id": target_id},
    )
    res2 = await client.get(
        "/api/v1/social/users/search", headers=auth(token), params={"query": "target"}
    )
    assert res2.json()[0]["friendship_status"] == "pending"


@pytest.mark.asyncio
async def test_friend_request_accept_and_leaderboard(
    client: AsyncClient, db_session: AsyncSession
) -> None:
    await create_user(db_session, email="a@example.com", username="alice", xp_total=100)
    b = await create_user(db_session, email="b@example.com", username="bob", xp_total=50)
    token_a = await login(client, email="a@example.com")
    token_b = await login(client, email="b@example.com")

    req = await client.post(
        "/api/v1/social/friends/request",
        headers=auth(token_a),
        json={"friend_id": b.id},
    )
    assert req.status_code == 201
    friendship_id = req.json()["id"]

    accept = await client.post(
        f"/api/v1/social/friends/{friendship_id}/accept", headers=auth(token_b)
    )
    assert accept.status_code == 200
    assert accept.json()["status"] == "accepted"

    lb = await client.get("/api/v1/social/friends/leaderboard", headers=auth(token_a))
    assert lb.status_code == 200
    usernames = [e["username"] for e in lb.json()]
    assert "alice" in usernames and "bob" in usernames
