import pytest
from httpx import AsyncClient
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.email import LogEmailSender, set_email_sender
from app.core.security import hash_token
from app.modules.auth.models import EmailVerificationToken, PasswordResetToken
from tests.helpers import auth, register_user


class CapturingEmailSender(LogEmailSender):
    def __init__(self) -> None:
        self.sent: list[dict] = []

    async def send(self, *, to: str, subject: str, body: str) -> None:
        self.sent.append({"to": to, "subject": subject, "body": body})


@pytest.mark.asyncio
async def test_forgot_and_reset_password(
    client: AsyncClient, db_session: AsyncSession
) -> None:
    sender = CapturingEmailSender()
    set_email_sender(sender)
    try:
        await register_user(client, email="reset@example.com", username="resetter")

        forgot = await client.post(
            "/api/v1/auth/forgot-password", json={"email": "reset@example.com"}
        )
        assert forgot.status_code == 200
        assert sender.sent, "reset email should have been dispatched"

        # Recover the raw token from the stored hash by re-deriving from the link.
        link = sender.sent[-1]["body"]
        raw_token = link.split("token=")[-1].strip()
        stored = await db_session.execute(select(PasswordResetToken))
        token_row = stored.scalars().first()
        assert token_row is not None
        assert token_row.token_hash == hash_token(raw_token)

        reset = await client.post(
            "/api/v1/auth/reset-password",
            json={"token": raw_token, "new_password": "brandnewpass9"},
        )
        assert reset.status_code == 200, reset.text

        # Old password no longer works, new one does.
        old = await client.post(
            "/api/v1/auth/login",
            json={"email": "reset@example.com", "password": "securepass1"},
        )
        assert old.status_code == 401
        new = await client.post(
            "/api/v1/auth/login",
            json={"email": "reset@example.com", "password": "brandnewpass9"},
        )
        assert new.status_code == 200

        # Token cannot be reused.
        reuse = await client.post(
            "/api/v1/auth/reset-password",
            json={"token": raw_token, "new_password": "anotherpass9"},
        )
        assert reuse.status_code == 400
    finally:
        set_email_sender(LogEmailSender())


@pytest.mark.asyncio
async def test_email_verification_flow(
    client: AsyncClient, db_session: AsyncSession
) -> None:
    sender = CapturingEmailSender()
    set_email_sender(sender)
    try:
        token = await register_user(client, email="verify@example.com", username="verifier")

        req = await client.post("/api/v1/auth/verify-email/request", headers=auth(token))
        assert req.status_code == 200
        assert sender.sent

        link = sender.sent[-1]["body"]
        raw_token = link.split("token=")[-1].strip()

        confirm = await client.post(
            "/api/v1/auth/verify-email/confirm", json={"token": raw_token}
        )
        assert confirm.status_code == 200, confirm.text

        me = await client.get("/api/v1/users/me", headers=auth(token))
        assert me.json()["is_email_verified"] is True

        stored = await db_session.execute(select(EmailVerificationToken))
        assert stored.scalars().first().verified_at is not None
    finally:
        set_email_sender(LogEmailSender())
