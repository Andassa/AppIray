from __future__ import annotations

import logging
from abc import ABC, abstractmethod
from collections.abc import Awaitable, Callable
from datetime import UTC, datetime
from typing import Any

from apscheduler.schedulers.asyncio import AsyncIOScheduler
from apscheduler.triggers.cron import CronTrigger
from apscheduler.triggers.interval import IntervalTrigger

logger = logging.getLogger(__name__)

JobFunc = Callable[..., Awaitable[Any]]


class TaskQueue(ABC):
    """Abstract background task interface.

    Phase 1: InProcessTaskQueue (APScheduler).
    Phase 2: swap for a Celery-backed implementation without changing callers.
    """

    @abstractmethod
    async def enqueue(self, func: JobFunc, *args: Any, **kwargs: Any) -> None:
        """Run a one-off job as soon as possible."""

    @abstractmethod
    def schedule_cron(
        self,
        job_id: str,
        func: JobFunc,
        *,
        cron: str,
        **kwargs: Any,
    ) -> None:
        """Schedule a recurring cron job. `cron` format: 'min hour day month dow'."""

    @abstractmethod
    def schedule_interval(
        self,
        job_id: str,
        func: JobFunc,
        *,
        seconds: int,
        **kwargs: Any,
    ) -> None:
        """Schedule a recurring interval job."""

    @abstractmethod
    def start(self) -> None: ...

    @abstractmethod
    def shutdown(self) -> None: ...


class InProcessTaskQueue(TaskQueue):
    def __init__(self) -> None:
        self._scheduler = AsyncIOScheduler()

    async def enqueue(self, func: JobFunc, *args: Any, **kwargs: Any) -> None:
        self._scheduler.add_job(
            func,
            trigger="date",
            run_date=datetime.now(UTC),
            args=args,
            kwargs=kwargs,
            misfire_grace_time=60,
        )

    def schedule_cron(
        self,
        job_id: str,
        func: JobFunc,
        *,
        cron: str,
        **kwargs: Any,
    ) -> None:
        minute, hour, day, month, day_of_week = cron.split()
        self._scheduler.add_job(
            func,
            CronTrigger(
                minute=minute,
                hour=hour,
                day=day,
                month=month,
                day_of_week=day_of_week,
            ),
            id=job_id,
            replace_existing=True,
            kwargs=kwargs,
        )

    def schedule_interval(
        self,
        job_id: str,
        func: JobFunc,
        *,
        seconds: int,
        **kwargs: Any,
    ) -> None:
        self._scheduler.add_job(
            func,
            IntervalTrigger(seconds=seconds),
            id=job_id,
            replace_existing=True,
            kwargs=kwargs,
        )

    def start(self) -> None:
        if not self._scheduler.running:
            self._scheduler.start()
            logger.info("InProcessTaskQueue started")

    def shutdown(self) -> None:
        if self._scheduler.running:
            self._scheduler.shutdown(wait=False)
            logger.info("InProcessTaskQueue shut down")


_task_queue: TaskQueue | None = None


def get_task_queue() -> TaskQueue:
    global _task_queue
    if _task_queue is None:
        _task_queue = InProcessTaskQueue()
    return _task_queue


def set_task_queue(queue: TaskQueue) -> None:
    global _task_queue
    _task_queue = queue
