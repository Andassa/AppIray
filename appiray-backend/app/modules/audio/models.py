from datetime import datetime
from uuid import uuid4

from sqlalchemy import DateTime, String, Text, func
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base


class AudioAsset(Base):
    __tablename__ = "audio_assets"

    id: Mapped[str] = mapped_column(
        UUID(as_uuid=False), primary_key=True, default=lambda: str(uuid4())
    )
    text_malagasy: Mapped[str] = mapped_column(Text, nullable=False, index=True)
    audio_url: Mapped[str] = mapped_column(String(512), nullable=False)
    voice_model_version: Mapped[str] = mapped_column(
        String(80), default="mms-tts-mlg", nullable=False
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), nullable=False
    )

    exercises = relationship("Exercise", back_populates="audio_asset")
