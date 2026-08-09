from fastapi import HTTPException, UploadFile
from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.storage import StorageBackend
from app.modules.audio.models import AudioAsset
from app.modules.audio.schemas import AudioAssetCreate, AudioAssetUpdate


class AudioService:
    """Manages pre-generated TTS audio assets. No realtime inference here."""

    def __init__(self, db: AsyncSession, storage: StorageBackend) -> None:
        self.db = db
        self.storage = storage

    async def create(self, data: AudioAssetCreate) -> AudioAsset:
        asset = AudioAsset(**data.model_dump())
        self.db.add(asset)
        await self.db.commit()
        await self.db.refresh(asset)
        return asset

    async def upload_and_create(
        self,
        *,
        text_malagasy: str,
        file: UploadFile,
        voice_model_version: str = "mms-tts-mlg",
    ) -> AudioAsset:
        content = await file.read()
        url = await self.storage.upload(
            content,
            content_type=file.content_type or "audio/mpeg",
            folder="audio",
        )
        return await self.create(
            AudioAssetCreate(
                text_malagasy=text_malagasy,
                audio_url=url,
                voice_model_version=voice_model_version,
            )
        )

    async def get(self, asset_id: str) -> AudioAsset:
        asset = await self.db.get(AudioAsset, asset_id)
        if asset is None:
            raise HTTPException(status_code=404, detail="Audio asset not found")
        return asset

    async def list(
        self,
        *,
        page: int,
        page_size: int,
        voice_model_version: str | None = None,
        text_malagasy: str | None = None,
    ) -> tuple[list[AudioAsset], int]:
        """Liste paginée (LIMIT/OFFSET SQL), même pattern que ContentService."""
        query = select(AudioAsset)
        count_q = select(func.count()).select_from(AudioAsset)

        if voice_model_version:
            query = query.where(AudioAsset.voice_model_version == voice_model_version)
            count_q = count_q.where(AudioAsset.voice_model_version == voice_model_version)
        if text_malagasy:
            # Recherche partielle (ILIKE) — simple et suffisante pour un check ciblé.
            pattern = f"%{text_malagasy}%"
            query = query.where(AudioAsset.text_malagasy.ilike(pattern))
            count_q = count_q.where(AudioAsset.text_malagasy.ilike(pattern))

        total = (await self.db.execute(count_q)).scalar_one()
        result = await self.db.execute(
            query.order_by(AudioAsset.created_at.desc())
            .offset((page - 1) * page_size)
            .limit(page_size)
        )
        return list(result.scalars().all()), total

    async def update(self, asset_id: str, data: AudioAssetUpdate) -> AudioAsset:
        asset = await self.get(asset_id)
        for key, value in data.model_dump(exclude_unset=True).items():
            setattr(asset, key, value)
        await self.db.commit()
        await self.db.refresh(asset)
        return asset

    async def delete(self, asset_id: str) -> None:
        asset = await self.get(asset_id)
        await self.storage.delete(asset.audio_url)
        await self.db.delete(asset)
        await self.db.commit()
