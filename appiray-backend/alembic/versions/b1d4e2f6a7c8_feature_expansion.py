"""feature expansion: auth tokens, hearts economy, quests, device tokens, content status

Revision ID: b1d4e2f6a7c8
Revises: c9b92c5b7451
Create Date: 2026-08-08 00:20:00.000000

"""

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

# revision identifiers, used by Alembic.
revision: str = "b1d4e2f6a7c8"
down_revision: str | None = "c9b92c5b7451"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    # --- users: new economy / verification columns ---
    op.add_column(
        "users",
        sa.Column(
            "is_email_verified",
            sa.Boolean(),
            nullable=False,
            server_default=sa.text("false"),
        ),
    )
    op.add_column(
        "users",
        sa.Column("gems", sa.Integer(), nullable=False, server_default=sa.text("0")),
    )
    op.add_column(
        "users",
        sa.Column("heart_refill_at", sa.DateTime(timezone=True), nullable=True),
    )
    op.add_column(
        "users",
        sa.Column("daily_xp_goal", sa.Integer(), nullable=False, server_default=sa.text("20")),
    )
    op.add_column("users", sa.Column("last_daily_goal_date", sa.Date(), nullable=True))

    # --- publications: editorial status ---
    op.add_column(
        "publications",
        sa.Column(
            "status",
            sa.Enum(
                "draft",
                "published",
                name="publication_status",
                native_enum=False,
            ),
            nullable=False,
            server_default="draft",
        ),
    )
    op.create_index(op.f("ix_publications_status"), "publications", ["status"], unique=False)

    # --- password reset tokens ---
    op.create_table(
        "password_reset_tokens",
        sa.Column("id", sa.UUID(as_uuid=False), nullable=False),
        sa.Column("user_id", sa.UUID(as_uuid=False), nullable=False),
        sa.Column("token_hash", sa.String(length=128), nullable=False),
        sa.Column("expires_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("used_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.ForeignKeyConstraint(["user_id"], ["users.id"], ondelete="CASCADE"),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index(
        op.f("ix_password_reset_tokens_user_id"),
        "password_reset_tokens",
        ["user_id"],
        unique=False,
    )
    op.create_index(
        op.f("ix_password_reset_tokens_token_hash"),
        "password_reset_tokens",
        ["token_hash"],
        unique=True,
    )

    # --- email verification tokens ---
    op.create_table(
        "email_verification_tokens",
        sa.Column("id", sa.UUID(as_uuid=False), nullable=False),
        sa.Column("user_id", sa.UUID(as_uuid=False), nullable=False),
        sa.Column("token_hash", sa.String(length=128), nullable=False),
        sa.Column("expires_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("verified_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.ForeignKeyConstraint(["user_id"], ["users.id"], ondelete="CASCADE"),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index(
        op.f("ix_email_verification_tokens_user_id"),
        "email_verification_tokens",
        ["user_id"],
        unique=False,
    )
    op.create_index(
        op.f("ix_email_verification_tokens_token_hash"),
        "email_verification_tokens",
        ["token_hash"],
        unique=True,
    )

    # --- streak freezes ---
    op.create_table(
        "streak_freezes",
        sa.Column("id", sa.UUID(as_uuid=False), nullable=False),
        sa.Column("user_id", sa.UUID(as_uuid=False), nullable=False),
        sa.Column("active_from", sa.DateTime(timezone=True), nullable=False),
        sa.Column("active_until", sa.DateTime(timezone=True), nullable=False),
        sa.Column("used", sa.Boolean(), nullable=False, server_default=sa.text("false")),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.ForeignKeyConstraint(["user_id"], ["users.id"], ondelete="CASCADE"),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index(op.f("ix_streak_freezes_user_id"), "streak_freezes", ["user_id"], unique=False)
    op.create_index(
        op.f("ix_streak_freezes_active_until"),
        "streak_freezes",
        ["active_until"],
        unique=False,
    )
    op.create_index(op.f("ix_streak_freezes_used"), "streak_freezes", ["used"], unique=False)

    # --- device tokens ---
    op.create_table(
        "device_tokens",
        sa.Column("id", sa.UUID(as_uuid=False), nullable=False),
        sa.Column("user_id", sa.UUID(as_uuid=False), nullable=False),
        sa.Column("token", sa.String(length=512), nullable=False),
        sa.Column(
            "platform",
            sa.Enum("ios", "android", name="device_platform", native_enum=False),
            nullable=False,
        ),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.Column(
            "last_seen_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.ForeignKeyConstraint(["user_id"], ["users.id"], ondelete="CASCADE"),
        sa.PrimaryKeyConstraint("id"),
        sa.UniqueConstraint("token", name="uq_device_token"),
    )
    op.create_index(op.f("ix_device_tokens_user_id"), "device_tokens", ["user_id"], unique=False)
    op.create_index(op.f("ix_device_tokens_token"), "device_tokens", ["token"], unique=False)

    # --- daily quests ---
    op.create_table(
        "daily_quests",
        sa.Column("id", sa.UUID(as_uuid=False), nullable=False),
        sa.Column("title", sa.String(length=160), nullable=False),
        sa.Column("description", sa.Text(), nullable=False),
        sa.Column("criteria", sa.JSON(), nullable=False),
        sa.Column("xp_reward", sa.Integer(), nullable=False, server_default=sa.text("0")),
        sa.Column("gem_reward", sa.Integer(), nullable=False, server_default=sa.text("0")),
        sa.PrimaryKeyConstraint("id"),
    )

    # --- user daily quests ---
    op.create_table(
        "user_daily_quests",
        sa.Column("id", sa.UUID(as_uuid=False), nullable=False),
        sa.Column("user_id", sa.UUID(as_uuid=False), nullable=False),
        sa.Column("quest_id", sa.UUID(as_uuid=False), nullable=False),
        sa.Column("date", sa.Date(), nullable=False),
        sa.Column("progress", sa.Integer(), nullable=False, server_default=sa.text("0")),
        sa.Column("completed_at", sa.DateTime(timezone=True), nullable=True),
        sa.ForeignKeyConstraint(["quest_id"], ["daily_quests.id"], ondelete="CASCADE"),
        sa.ForeignKeyConstraint(["user_id"], ["users.id"], ondelete="CASCADE"),
        sa.PrimaryKeyConstraint("id"),
        sa.UniqueConstraint("user_id", "quest_id", "date", name="uq_user_quest_date"),
    )
    op.create_index(
        op.f("ix_user_daily_quests_user_id"),
        "user_daily_quests",
        ["user_id"],
        unique=False,
    )
    op.create_index(
        op.f("ix_user_daily_quests_quest_id"),
        "user_daily_quests",
        ["quest_id"],
        unique=False,
    )
    op.create_index(op.f("ix_user_daily_quests_date"), "user_daily_quests", ["date"], unique=False)


def downgrade() -> None:
    op.drop_index(op.f("ix_user_daily_quests_date"), table_name="user_daily_quests")
    op.drop_index(op.f("ix_user_daily_quests_quest_id"), table_name="user_daily_quests")
    op.drop_index(op.f("ix_user_daily_quests_user_id"), table_name="user_daily_quests")
    op.drop_table("user_daily_quests")
    op.drop_table("daily_quests")

    op.drop_index(op.f("ix_device_tokens_token"), table_name="device_tokens")
    op.drop_index(op.f("ix_device_tokens_user_id"), table_name="device_tokens")
    op.drop_table("device_tokens")

    op.drop_index(op.f("ix_streak_freezes_used"), table_name="streak_freezes")
    op.drop_index(op.f("ix_streak_freezes_active_until"), table_name="streak_freezes")
    op.drop_index(op.f("ix_streak_freezes_user_id"), table_name="streak_freezes")
    op.drop_table("streak_freezes")

    op.drop_index(
        op.f("ix_email_verification_tokens_token_hash"),
        table_name="email_verification_tokens",
    )
    op.drop_index(
        op.f("ix_email_verification_tokens_user_id"),
        table_name="email_verification_tokens",
    )
    op.drop_table("email_verification_tokens")

    op.drop_index(
        op.f("ix_password_reset_tokens_token_hash"),
        table_name="password_reset_tokens",
    )
    op.drop_index(op.f("ix_password_reset_tokens_user_id"), table_name="password_reset_tokens")
    op.drop_table("password_reset_tokens")

    op.drop_index(op.f("ix_publications_status"), table_name="publications")
    op.drop_column("publications", "status")

    op.drop_column("users", "last_daily_goal_date")
    op.drop_column("users", "daily_xp_goal")
    op.drop_column("users", "heart_refill_at")
    op.drop_column("users", "gems")
    op.drop_column("users", "is_email_verified")
