from datetime import datetime

from pydantic import BaseModel, ConfigDict, Field

from app.core.enums import PublicationCategory


class PublicationCreate(BaseModel):
    title: str = Field(min_length=1, max_length=255)
    body: str = Field(min_length=1)
    category: PublicationCategory
    cover_image_url: str | None = None
    author: str = Field(min_length=1, max_length=120)


class PublicationUpdate(BaseModel):
    title: str | None = None
    body: str | None = None
    category: PublicationCategory | None = None
    cover_image_url: str | None = None
    author: str | None = None


class PublicationRead(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    title: str
    body: str
    category: PublicationCategory
    cover_image_url: str | None
    author: str
    published_at: datetime
    likes_count: int = 0
    comments_count: int = 0


class CommentCreate(BaseModel):
    body: str = Field(min_length=1, max_length=2000)


class CommentRead(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    publication_id: str
    user_id: str
    body: str
    created_at: datetime


class PaginatedPublications(BaseModel):
    items: list[PublicationRead]
    total: int
    page: int
    page_size: int
