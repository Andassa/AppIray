import mimetypes
import uuid
from abc import ABC, abstractmethod
from pathlib import Path

import boto3
from botocore.client import Config

from app.core.config import Settings, get_settings


class StorageBackend(ABC):
    """Abstract storage interface — local in dev, S3/R2 in prod."""

    @abstractmethod
    async def upload(
        self,
        data: bytes,
        *,
        key: str | None = None,
        content_type: str | None = None,
        folder: str = "uploads",
    ) -> str:
        """Upload bytes and return a public URL."""

    @abstractmethod
    async def delete(self, key_or_url: str) -> None:
        """Delete an object by key or URL."""


class LocalStorageBackend(StorageBackend):
    def __init__(self, root: str, public_base_url: str) -> None:
        self.root = Path(root)
        self.public_base_url = public_base_url.rstrip("/")
        self.root.mkdir(parents=True, exist_ok=True)

    def _resolve_key(self, key: str) -> Path:
        path = (self.root / key).resolve()
        if not str(path).startswith(str(self.root.resolve())):
            raise ValueError("Invalid storage key")
        return path

    async def upload(
        self,
        data: bytes,
        *,
        key: str | None = None,
        content_type: str | None = None,
        folder: str = "uploads",
    ) -> str:
        ext = mimetypes.guess_extension(content_type or "") or ""
        relative = key or f"{folder}/{uuid.uuid4().hex}{ext}"
        path = self._resolve_key(relative)
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(data)
        return f"{self.public_base_url}/{relative}"

    async def delete(self, key_or_url: str) -> None:
        key = key_or_url
        if key_or_url.startswith(self.public_base_url):
            key = key_or_url[len(self.public_base_url) + 1 :]
        path = self._resolve_key(key)
        if path.exists():
            path.unlink()


class S3StorageBackend(StorageBackend):
    def __init__(self, settings: Settings) -> None:
        self.bucket = settings.S3_BUCKET_NAME
        self.public_base_url = settings.PUBLIC_ASSET_BASE_URL.rstrip("/")
        self.client = boto3.client(
            "s3",
            endpoint_url=settings.S3_ENDPOINT_URL,
            aws_access_key_id=settings.S3_ACCESS_KEY_ID,
            aws_secret_access_key=settings.S3_SECRET_ACCESS_KEY,
            region_name=settings.S3_REGION,
            config=Config(signature_version="s3v4"),
        )

    async def upload(
        self,
        data: bytes,
        *,
        key: str | None = None,
        content_type: str | None = None,
        folder: str = "uploads",
    ) -> str:
        relative = key or f"{folder}/{uuid.uuid4().hex}"
        extra = {"ContentType": content_type} if content_type else {}
        self.client.put_object(
            Bucket=self.bucket,
            Key=relative,
            Body=data,
            **extra,
        )
        return f"{self.public_base_url}/{relative}"

    async def delete(self, key_or_url: str) -> None:
        key = key_or_url
        if key_or_url.startswith(self.public_base_url):
            key = key_or_url[len(self.public_base_url) + 1 :]
        self.client.delete_object(Bucket=self.bucket, Key=key)


def get_storage() -> StorageBackend:
    settings = get_settings()
    if settings.STORAGE_BACKEND.lower() == "s3":
        return S3StorageBackend(settings)
    return LocalStorageBackend(settings.STORAGE_LOCAL_PATH, settings.PUBLIC_ASSET_BASE_URL)
