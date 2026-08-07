from __future__ import annotations

import logging
from abc import ABC, abstractmethod

from app.core.config import get_settings

logger = logging.getLogger(__name__)


class EmailSender(ABC):
    """Abstract transactional email interface.

    Phase 1: LogEmailSender (writes to server logs, no provider configured).
    Phase 2: swap for a Resend / SendGrid / SES backed implementation without
    changing any calling code (same pattern as TaskQueue / StorageBackend).
    """

    @abstractmethod
    async def send(self, *, to: str, subject: str, body: str) -> None:
        """Send a plain-text email."""


class LogEmailSender(EmailSender):
    async def send(self, *, to: str, subject: str, body: str) -> None:
        logger.info("[EMAIL] to=%s subject=%s\n%s", to, subject, body)


_email_sender: EmailSender | None = None


def get_email_sender() -> EmailSender:
    global _email_sender
    if _email_sender is None:
        settings = get_settings()
        # Only the "log" backend ships by default; real providers are added in Phase 2.
        if settings.EMAIL_SENDER_BACKEND.lower() == "log":
            _email_sender = LogEmailSender()
        else:
            logger.warning(
                "Unknown EMAIL_SENDER_BACKEND=%s, falling back to log",
                settings.EMAIL_SENDER_BACKEND,
            )
            _email_sender = LogEmailSender()
    return _email_sender


def set_email_sender(sender: EmailSender) -> None:
    global _email_sender
    _email_sender = sender
