from datetime import datetime
from uuid import uuid4

from sqlalchemy import (
    JSON,
    DateTime,
    Enum,
    ForeignKey,
    Integer,
    String,
    Text,
    UniqueConstraint,
    func,
)
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base
from app.core.enums import ExerciseType


class Course(Base):
    __tablename__ = "courses"

    id: Mapped[str] = mapped_column(
        UUID(as_uuid=False), primary_key=True, default=lambda: str(uuid4())
    )
    title: Mapped[str] = mapped_column(String(200), nullable=False)
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    target_language: Mapped[str] = mapped_column(String(80), default="malagasy", nullable=False)
    source_language: Mapped[str] = mapped_column(String(80), default="français", nullable=False)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), nullable=False
    )

    units = relationship(
        "Unit", back_populates="course", cascade="all, delete-orphan", order_by="Unit.order"
    )


class Unit(Base):
    __tablename__ = "units"
    __table_args__ = (UniqueConstraint("course_id", "order", name="uq_unit_course_order"),)

    id: Mapped[str] = mapped_column(
        UUID(as_uuid=False), primary_key=True, default=lambda: str(uuid4())
    )
    course_id: Mapped[str] = mapped_column(
        UUID(as_uuid=False), ForeignKey("courses.id", ondelete="CASCADE"), index=True
    )
    title: Mapped[str] = mapped_column(String(200), nullable=False)
    order: Mapped[int] = mapped_column(Integer, nullable=False)

    course = relationship("Course", back_populates="units")
    lessons = relationship(
        "Lesson", back_populates="unit", cascade="all, delete-orphan", order_by="Lesson.order"
    )


class Lesson(Base):
    __tablename__ = "lessons"
    __table_args__ = (UniqueConstraint("unit_id", "order", name="uq_lesson_unit_order"),)

    id: Mapped[str] = mapped_column(
        UUID(as_uuid=False), primary_key=True, default=lambda: str(uuid4())
    )
    unit_id: Mapped[str] = mapped_column(
        UUID(as_uuid=False), ForeignKey("units.id", ondelete="CASCADE"), index=True
    )
    title: Mapped[str] = mapped_column(String(200), nullable=False)
    order: Mapped[int] = mapped_column(Integer, nullable=False)
    xp_reward: Mapped[int] = mapped_column(Integer, default=20, nullable=False)

    unit = relationship("Unit", back_populates="lessons")
    exercises = relationship(
        "Exercise",
        back_populates="lesson",
        cascade="all, delete-orphan",
    )
    progress = relationship("UserProgress", back_populates="lesson")


class Exercise(Base):
    __tablename__ = "exercises"

    id: Mapped[str] = mapped_column(
        UUID(as_uuid=False), primary_key=True, default=lambda: str(uuid4())
    )
    lesson_id: Mapped[str] = mapped_column(
        UUID(as_uuid=False), ForeignKey("lessons.id", ondelete="CASCADE"), index=True
    )
    type: Mapped[ExerciseType] = mapped_column(
        Enum(ExerciseType, name="exercise_type", values_callable=lambda x: [e.value for e in x], native_enum=False),
        nullable=False,
    )
    content: Mapped[dict] = mapped_column(JSON, nullable=False, default=dict)
    correct_answer: Mapped[str] = mapped_column(Text, nullable=False)
    audio_asset_id: Mapped[str | None] = mapped_column(
        UUID(as_uuid=False),
        ForeignKey("audio_assets.id", ondelete="SET NULL"),
        nullable=True,
        index=True,
    )
    order: Mapped[int] = mapped_column(Integer, default=0, nullable=False)

    lesson = relationship("Lesson", back_populates="exercises")
    audio_asset = relationship("AudioAsset", back_populates="exercises")
    attempts = relationship("ExerciseAttempt", back_populates="exercise")
