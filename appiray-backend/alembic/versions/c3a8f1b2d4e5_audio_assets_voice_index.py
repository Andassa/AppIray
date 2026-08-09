"""Add index on audio_assets.voice_model_version.

Revision ID: c3a8f1b2d4e5
Revises: b1d4e2f6a7c8
Create Date: 2026-08-09

text_malagasy was already indexed in the initial schema.
"""

from collections.abc import Sequence

from alembic import op

revision: str = "c3a8f1b2d4e5"
down_revision: str | None = "b1d4e2f6a7c8"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.create_index(
        op.f("ix_audio_assets_voice_model_version"),
        "audio_assets",
        ["voice_model_version"],
        unique=False,
    )


def downgrade() -> None:
    op.drop_index(op.f("ix_audio_assets_voice_model_version"), table_name="audio_assets")
