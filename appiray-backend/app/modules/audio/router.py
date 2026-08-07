from fastapi import APIRouter, File, Form, Query, UploadFile

from app.core.deps import CurrentAdmin, CurrentUser, DbSession, Storage
from app.modules.audio.schemas import AudioAssetCreate, AudioAssetRead, AudioAssetUpdate
from app.modules.audio.service import AudioService

router = APIRouter(prefix="/audio", tags=["audio"])


@router.get("/assets", response_model=list[AudioAssetRead])
async def list_assets(
    db: DbSession,
    storage: Storage,
    _: CurrentUser,
    q: str | None = None,
    limit: int = Query(default=50, ge=1, le=200),
) -> list[AudioAssetRead]:
    assets = await AudioService(db, storage).list(q=q, limit=limit)
    return [AudioAssetRead.model_validate(a) for a in assets]


@router.get("/assets/{asset_id}", response_model=AudioAssetRead)
async def get_asset(
    asset_id: str, db: DbSession, storage: Storage, _: CurrentUser
) -> AudioAssetRead:
    asset = await AudioService(db, storage).get(asset_id)
    return AudioAssetRead.model_validate(asset)


@router.post("/assets", response_model=AudioAssetRead, status_code=201)
async def create_asset(
    data: AudioAssetCreate, db: DbSession, storage: Storage, _: CurrentAdmin
) -> AudioAssetRead:
    asset = await AudioService(db, storage).create(data)
    return AudioAssetRead.model_validate(asset)


@router.post("/assets/upload", response_model=AudioAssetRead, status_code=201)
async def upload_asset(
    db: DbSession,
    storage: Storage,
    _: CurrentAdmin,
    text_malagasy: str = Form(...),
    voice_model_version: str = Form(default="mms-tts-mlg"),
    file: UploadFile = File(...),
) -> AudioAssetRead:
    asset = await AudioService(db, storage).upload_and_create(
        text_malagasy=text_malagasy,
        file=file,
        voice_model_version=voice_model_version,
    )
    return AudioAssetRead.model_validate(asset)


@router.patch("/assets/{asset_id}", response_model=AudioAssetRead)
async def update_asset(
    asset_id: str,
    data: AudioAssetUpdate,
    db: DbSession,
    storage: Storage,
    _: CurrentAdmin,
) -> AudioAssetRead:
    asset = await AudioService(db, storage).update(asset_id, data)
    return AudioAssetRead.model_validate(asset)


@router.delete("/assets/{asset_id}", status_code=204)
async def delete_asset(
    asset_id: str, db: DbSession, storage: Storage, _: CurrentAdmin
) -> None:
    await AudioService(db, storage).delete(asset_id)
