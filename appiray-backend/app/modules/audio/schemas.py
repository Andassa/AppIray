from datetime import datetime

from pydantic import BaseModel, ConfigDict, Field


class AudioAssetCreate(BaseModel):
    text_malagasy: str = Field(min_length=1)
    audio_url: str = Field(min_length=1)
    voice_model_version: str = "mms-tts-mlg"


class AudioAssetUpdate(BaseModel):
    text_malagasy: str | None = None
    audio_url: str | None = None
    voice_model_version: str | None = None


class AudioAssetRead(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    text_malagasy: str
    audio_url: str
    voice_model_version: str
    created_at: datetime
