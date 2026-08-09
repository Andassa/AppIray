from fastapi import APIRouter, Query

from app.core.deps import CurrentAdmin, CurrentUser, DbSession
from app.core.enums import PublicationCategory, PublicationStatus
from app.modules.content.schemas import (
    CommentCreate,
    CommentRead,
    PaginatedPublications,
    PublicationCreate,
    PublicationRead,
    PublicationUpdate,
)
from app.modules.content.service import ContentService

router = APIRouter(prefix="/content", tags=["content"])


@router.get("/publications", response_model=PaginatedPublications)
async def list_publications(
    db: DbSession,
    page: int = Query(default=1, ge=1),
    page_size: int = Query(default=20, ge=1, le=100),
    category: PublicationCategory | None = None,
) -> PaginatedPublications:
    items, total = await ContentService(db).list_publications(
        page=page, page_size=page_size, category=category, published_only=True
    )
    return PaginatedPublications(items=items, total=total, page=page, page_size=page_size)


@router.get("/admin/publications", response_model=PaginatedPublications)
async def admin_list_publications(
    db: DbSession,
    _: CurrentAdmin,
    page: int = Query(default=1, ge=1),
    page_size: int = Query(default=20, ge=1, le=100),
    category: PublicationCategory | None = None,
    status: PublicationStatus | None = None,
) -> PaginatedPublications:
    items, total = await ContentService(db).list_publications(
        page=page,
        page_size=page_size,
        category=category,
        published_only=False,
        status=status,
    )
    return PaginatedPublications(items=items, total=total, page=page, page_size=page_size)


@router.get("/publications/{publication_id}", response_model=PublicationRead)
async def get_publication(publication_id: str, db: DbSession) -> PublicationRead:
    return await ContentService(db).get_publication(publication_id, published_only=True)


@router.post("/publications", response_model=PublicationRead, status_code=201)
async def create_publication(
    data: PublicationCreate, db: DbSession, _: CurrentAdmin
) -> PublicationRead:
    pub = await ContentService(db).create_publication(data)
    return await ContentService(db).get_publication(pub.id, published_only=False)


@router.patch("/publications/{publication_id}", response_model=PublicationRead)
async def update_publication(
    publication_id: str,
    data: PublicationUpdate,
    db: DbSession,
    _: CurrentAdmin,
) -> PublicationRead:
    await ContentService(db).update_publication(publication_id, data)
    return await ContentService(db).get_publication(publication_id, published_only=False)


@router.post("/publications/{publication_id}/publish", response_model=PublicationRead)
async def publish_publication(
    publication_id: str, db: DbSession, _: CurrentAdmin
) -> PublicationRead:
    return await ContentService(db).publish(publication_id)


@router.delete("/publications/{publication_id}", status_code=204)
async def delete_publication(publication_id: str, db: DbSession, _: CurrentAdmin) -> None:
    await ContentService(db).delete_publication(publication_id)


@router.post("/publications/{publication_id}/like", status_code=204)
async def like_publication(publication_id: str, user: CurrentUser, db: DbSession) -> None:
    await ContentService(db).like(user, publication_id)


@router.delete("/publications/{publication_id}/like", status_code=204)
async def unlike_publication(publication_id: str, user: CurrentUser, db: DbSession) -> None:
    await ContentService(db).unlike(user, publication_id)


@router.post(
    "/publications/{publication_id}/comments",
    response_model=CommentRead,
    status_code=201,
)
async def add_comment(
    publication_id: str,
    data: CommentCreate,
    user: CurrentUser,
    db: DbSession,
) -> CommentRead:
    comment = await ContentService(db).add_comment(user, publication_id, data)
    return CommentRead.model_validate(comment)


@router.get(
    "/publications/{publication_id}/comments",
    response_model=list[CommentRead],
)
async def list_comments(publication_id: str, db: DbSession) -> list[CommentRead]:
    comments = await ContentService(db).list_comments(publication_id)
    return [CommentRead.model_validate(c) for c in comments]


@router.delete(
    "/publications/{publication_id}/comments/{comment_id}",
    status_code=204,
)
async def delete_comment(
    publication_id: str,
    comment_id: str,
    user: CurrentUser,
    db: DbSession,
) -> None:
    await ContentService(db).delete_comment(user, publication_id, comment_id)
