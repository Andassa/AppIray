from datetime import datetime
from uuid import uuid4

from sqlalchemy import (
    DateTime,
    Enum,
    ForeignKey,
    String,
    Text,
    UniqueConstraint,
    func,
)
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base
from app.core.enums import PublicationCategory, PublicationStatus


class Publication(Base):
    __tablename__ = "publications"

    id: Mapped[str] = mapped_column(
        UUID(as_uuid=False), primary_key=True, default=lambda: str(uuid4())
    )
    title: Mapped[str] = mapped_column(String(255), nullable=False)
    body: Mapped[str] = mapped_column(Text, nullable=False)
    category: Mapped[PublicationCategory] = mapped_column(
        Enum(
            PublicationCategory,
            name="publication_category",
            values_callable=lambda x: [e.value for e in x],
            native_enum=False,
        ),
        nullable=False,
        index=True,
    )
    status: Mapped[PublicationStatus] = mapped_column(
        Enum(
            PublicationStatus,
            name="publication_status",
            values_callable=lambda x: [e.value for e in x],
            native_enum=False,
        ),
        default=PublicationStatus.DRAFT,
        nullable=False,
        index=True,
    )
    cover_image_url: Mapped[str | None] = mapped_column(String(512), nullable=True)
    author: Mapped[str] = mapped_column(String(120), nullable=False)
    published_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), nullable=False, index=True
    )

    likes = relationship(
        "PublicationLike", back_populates="publication", cascade="all, delete-orphan"
    )
    comments = relationship(
        "PublicationComment",
        back_populates="publication",
        cascade="all, delete-orphan",
        order_by="PublicationComment.created_at",
    )


class PublicationLike(Base):
    __tablename__ = "publication_likes"
    __table_args__ = (UniqueConstraint("publication_id", "user_id", name="uq_publication_like"),)

    id: Mapped[str] = mapped_column(
        UUID(as_uuid=False), primary_key=True, default=lambda: str(uuid4())
    )
    publication_id: Mapped[str] = mapped_column(
        UUID(as_uuid=False),
        ForeignKey("publications.id", ondelete="CASCADE"),
        index=True,
    )
    user_id: Mapped[str] = mapped_column(
        UUID(as_uuid=False), ForeignKey("users.id", ondelete="CASCADE"), index=True
    )

    publication = relationship("Publication", back_populates="likes")
    user = relationship("User")


class PublicationComment(Base):
    __tablename__ = "publication_comments"

    id: Mapped[str] = mapped_column(
        UUID(as_uuid=False), primary_key=True, default=lambda: str(uuid4())
    )
    publication_id: Mapped[str] = mapped_column(
        UUID(as_uuid=False),
        ForeignKey("publications.id", ondelete="CASCADE"),
        index=True,
    )
    user_id: Mapped[str] = mapped_column(
        UUID(as_uuid=False), ForeignKey("users.id", ondelete="CASCADE"), index=True
    )
    body: Mapped[str] = mapped_column(Text, nullable=False)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), nullable=False, index=True
    )

    publication = relationship("Publication", back_populates="comments")
    user = relationship("User")
