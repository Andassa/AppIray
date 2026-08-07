from __future__ import annotations

import logging
from abc import ABC, abstractmethod
from typing import Any

from app.core.config import get_settings

logger = logging.getLogger(__name__)


class PushSender(ABC):
    """Abstract push-notification interface.

    Phase 1: LogPushSender (writes to server logs, no FCM/APNs configured).
    Phase 2: swap for an FCM / APNs backed implementation without changing
    callers (same pattern as TaskQueue / EmailSender / StorageBackend).
    """

    @abstractmethod
    async def send(
        self,
        *,
        tokens: list[str],
        title: str,
        body: str,
        data: dict[str, Any] | None = None,
    ) -> None:
        """Send a push notification to one or more device tokens."""


class LogPushSender(PushSender):
    async def send(
        self,
        *,
        tokens: list[str],
        title: str,
        body: str,
        data: dict[str, Any] | None = None,
    ) -> None:
        logger.info(
            "[PUSH] tokens=%s title=%s body=%s data=%s",
            tokens,
            title,
            body,
            data or {},
        )


_push_sender: PushSender | None = None


def get_push_sender() -> PushSender:
    global _push_sender
    if _push_sender is None:
        settings = get_settings()
        if settings.PUSH_SENDER_BACKEND.lower() == "log":
            _push_sender = LogPushSender()
        else:
            logger.warning(
                "Unknown PUSH_SENDER_BACKEND=%s, falling back to log",
                settings.PUSH_SENDER_BACKEND,
            )
            _push_sender = LogPushSender()
    return _push_sender


def set_push_sender(sender: PushSender) -> None:
    global _push_sender
    _push_sender = sender
