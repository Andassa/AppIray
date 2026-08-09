from datetime import date, datetime
from uuid import uuid4

from sqlalchemy import (
    JSON,
    Date,
    DateTime,
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


class League(Base):
    __tablename__ = "leagues"
    __table_args__ = (UniqueConstraint("tier", "week_start", name="uq_league_tier_week"),)

    id: Mapped[str] = mapped_column(
        UUID(as_uuid=False), primary_key=True, default=lambda: str(uuid4())
    )
    name: Mapped[str] = mapped_column(String(120), nullable=False)
    tier: Mapped[int] = mapped_column(Integer, nullable=False, index=True)
    week_start: Mapped[date] = mapped_column(Date, nullable=False, index=True)
    week_end: Mapped[date] = mapped_column(Date, nullable=False)

    memberships = relationship(
        "LeagueMembership", back_populates="league", cascade="all, delete-orphan"
    )


class LeagueMembership(Base):
    __tablename__ = "league_memberships"
    __table_args__ = (UniqueConstraint("league_id", "user_id", name="uq_league_user"),)

    id: Mapped[str] = mapped_column(
        UUID(as_uuid=False), primary_key=True, default=lambda: str(uuid4())
    )
    league_id: Mapped[str] = mapped_column(
        UUID(as_uuid=False), ForeignKey("leagues.id", ondelete="CASCADE"), index=True
    )
    user_id: Mapped[str] = mapped_column(
        UUID(as_uuid=False), ForeignKey("users.id", ondelete="CASCADE"), index=True
    )
    xp_this_week: Mapped[int] = mapped_column(Integer, default=0, nullable=False)

    league = relationship("League", back_populates="memberships")
    user = relationship("User")


class Badge(Base):
    __tablename__ = "badges"

    id: Mapped[str] = mapped_column(
        UUID(as_uuid=False), primary_key=True, default=lambda: str(uuid4())
    )
    name: Mapped[str] = mapped_column(String(120), unique=True, nullable=False)
    description: Mapped[str] = mapped_column(Text, nullable=False)
    icon_url: Mapped[str | None] = mapped_column(String(512), nullable=True)
    criteria: Mapped[dict] = mapped_column(JSON, nullable=False, default=dict)

    user_badges = relationship("UserBadge", back_populates="badge")


class UserBadge(Base):
    __tablename__ = "user_badges"
    __table_args__ = (UniqueConstraint("user_id", "badge_id", name="uq_user_badge"),)

    id: Mapped[str] = mapped_column(
        UUID(as_uuid=False), primary_key=True, default=lambda: str(uuid4())
    )
    user_id: Mapped[str] = mapped_column(
        UUID(as_uuid=False), ForeignKey("users.id", ondelete="CASCADE"), index=True
    )
    badge_id: Mapped[str] = mapped_column(
        UUID(as_uuid=False), ForeignKey("badges.id", ondelete="CASCADE"), index=True
    )
    earned_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), nullable=False
    )

    badge = relationship("Badge", back_populates="user_badges")
    user = relationship("User")


class DailyQuest(Base):
    __tablename__ = "daily_quests"

    id: Mapped[str] = mapped_column(
        UUID(as_uuid=False), primary_key=True, default=lambda: str(uuid4())
    )
    title: Mapped[str] = mapped_column(String(160), nullable=False)
    description: Mapped[str] = mapped_column(Text, nullable=False)
    # criteria e.g. {"type": "lessons_completed", "target": 3}
    criteria: Mapped[dict] = mapped_column(JSON, nullable=False, default=dict)
    xp_reward: Mapped[int] = mapped_column(Integer, default=0, nullable=False)
    gem_reward: Mapped[int] = mapped_column(Integer, default=0, nullable=False)

    user_quests = relationship("UserDailyQuest", back_populates="quest")


class UserDailyQuest(Base):
    __tablename__ = "user_daily_quests"
    __table_args__ = (UniqueConstraint("user_id", "quest_id", "date", name="uq_user_quest_date"),)

    id: Mapped[str] = mapped_column(
        UUID(as_uuid=False), primary_key=True, default=lambda: str(uuid4())
    )
    user_id: Mapped[str] = mapped_column(
        UUID(as_uuid=False), ForeignKey("users.id", ondelete="CASCADE"), index=True
    )
    quest_id: Mapped[str] = mapped_column(
        UUID(as_uuid=False), ForeignKey("daily_quests.id", ondelete="CASCADE"), index=True
    )
    date: Mapped[date] = mapped_column(Date, nullable=False, index=True)
    progress: Mapped[int] = mapped_column(Integer, default=0, nullable=False)
    completed_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)

    quest = relationship("DailyQuest", back_populates="user_quests")
    user = relationship("User")
