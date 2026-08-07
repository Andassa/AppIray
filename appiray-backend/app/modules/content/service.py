from datetime import UTC, datetime

from fastapi import HTTPException
from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.core.enums import PublicationCategory, PublicationStatus, UserRole
from app.modules.content.models import Publication, PublicationComment, PublicationLike
from app.modules.content.schemas import (
    CommentCreate,
    PublicationCreate,
    PublicationRead,
    PublicationUpdate,
)
from app.modules.users.models import User


def _to_read(pub: Publication) -> PublicationRead:
    return PublicationRead(
        id=pub.id,
        title=pub.title,
        body=pub.body,
        category=pub.category,
        status=pub.status,
        cover_image_url=pub.cover_image_url,
        author=pub.author,
        published_at=pub.published_at,
        likes_count=len(pub.likes),
        comments_count=len(pub.comments),
    )


class ContentService:
    def __init__(self, db: AsyncSession) -> None:
        self.db = db

    async def create_publication(self, data: PublicationCreate) -> Publication:
        pub = Publication(**data.model_dump())
        self.db.add(pub)
        await self.db.commit()
        await self.db.refresh(pub)
        return pub

    async def update_publication(self, pub_id: str, data: PublicationUpdate) -> Publication:
        pub = await self._get(pub_id)
        for key, value in data.model_dump(exclude_unset=True).items():
            setattr(pub, key, value)
        await self.db.commit()
        await self.db.refresh(pub)
        return pub

    async def delete_publication(self, pub_id: str) -> None:
        pub = await self._get(pub_id)
        await self.db.delete(pub)
        await self.db.commit()

    async def list_publications(
        self,
        *,
        page: int,
        page_size: int,
        category: PublicationCategory | None = None,
        published_only: bool = True,
        status: PublicationStatus | None = None,
    ) -> tuple[list[PublicationRead], int]:
        query = select(Publication)
        count_q = select(func.count()).select_from(Publication)
        if category:
            query = query.where(Publication.category == category)
            count_q = count_q.where(Publication.category == category)
        if published_only:
            query = query.where(Publication.status == PublicationStatus.PUBLISHED)
            count_q = count_q.where(Publication.status == PublicationStatus.PUBLISHED)
        elif status is not None:
            query = query.where(Publication.status == status)
            count_q = count_q.where(Publication.status == status)

        total = (await self.db.execute(count_q)).scalar_one()
        result = await self.db.execute(
            query.order_by(Publication.published_at.desc())
            .offset((page - 1) * page_size)
            .limit(page_size)
            .options(selectinload(Publication.likes), selectinload(Publication.comments))
        )
        pubs = list(result.scalars().all())
        return [_to_read(p) for p in pubs], total

    async def get_publication(
        self, pub_id: str, *, published_only: bool = True
    ) -> PublicationRead:
        result = await self.db.execute(
            select(Publication)
            .where(Publication.id == pub_id)
            .options(selectinload(Publication.likes), selectinload(Publication.comments))
        )
        pub = result.scalar_one_or_none()
        if pub is None:
            raise HTTPException(status_code=404, detail="Publication not found")
        if published_only and pub.status != PublicationStatus.PUBLISHED:
            raise HTTPException(status_code=404, detail="Publication not found")
        return _to_read(pub)

    async def publish(self, pub_id: str) -> PublicationRead:
        pub = await self._get(pub_id)
        pub.status = PublicationStatus.PUBLISHED
        pub.published_at = datetime.now(UTC)
        await self.db.commit()
        return await self.get_publication(pub_id, published_only=False)

    async def delete_comment(self, user: User, pub_id: str, comment_id: str) -> None:
        comment = await self.db.get(PublicationComment, comment_id)
        if comment is None or comment.publication_id != pub_id:
            raise HTTPException(status_code=404, detail="Comment not found")
        if comment.user_id != user.id and user.role != UserRole.ADMIN:
            raise HTTPException(
                status_code=403, detail="Not allowed to delete this comment"
            )
        await self.db.delete(comment)
        await self.db.commit()

    async def like(self, user: User, pub_id: str) -> None:
        await self._get(pub_id)
        existing = await self.db.execute(
            select(PublicationLike).where(
                PublicationLike.publication_id == pub_id,
                PublicationLike.user_id == user.id,
            )
        )
        if existing.scalar_one_or_none():
            return
        self.db.add(PublicationLike(publication_id=pub_id, user_id=user.id))
        await self.db.commit()

    async def unlike(self, user: User, pub_id: str) -> None:
        result = await self.db.execute(
            select(PublicationLike).where(
                PublicationLike.publication_id == pub_id,
                PublicationLike.user_id == user.id,
            )
        )
        like = result.scalar_one_or_none()
        if like:
            await self.db.delete(like)
            await self.db.commit()

    async def add_comment(
        self, user: User, pub_id: str, data: CommentCreate
    ) -> PublicationComment:
        await self._get(pub_id)
        comment = PublicationComment(
            publication_id=pub_id, user_id=user.id, body=data.body
        )
        self.db.add(comment)
        await self.db.commit()
        await self.db.refresh(comment)
        return comment

    async def list_comments(self, pub_id: str) -> list[PublicationComment]:
        await self._get(pub_id)
        result = await self.db.execute(
            select(PublicationComment)
            .where(PublicationComment.publication_id == pub_id)
            .order_by(PublicationComment.created_at.asc())
        )
        return list(result.scalars().all())

    async def _get(self, pub_id: str) -> Publication:
        pub = await self.db.get(Publication, pub_id)
        if pub is None:
            raise HTTPException(status_code=404, detail="Publication not found")
        return pub
