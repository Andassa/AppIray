from fastapi import APIRouter, File, UploadFile

from app.core.deps import CurrentUser, DbSession, Storage
from app.modules.users.schemas import UserRead, UserUpdate
from app.modules.users.service import UserService

router = APIRouter(prefix="/users", tags=["users"])


@router.get("/me", response_model=UserRead)
async def get_me(user: CurrentUser) -> UserRead:
    return UserRead.model_validate(user)


@router.patch("/me", response_model=UserRead)
async def update_me(
    data: UserUpdate,
    user: CurrentUser,
    db: DbSession,
    storage: Storage,
) -> UserRead:
    updated = await UserService(db, storage).update_profile(user, data)
    return UserRead.model_validate(updated)


@router.post("/me/avatar", response_model=UserRead)
async def upload_avatar(
    user: CurrentUser,
    db: DbSession,
    storage: Storage,
    file: UploadFile = File(...),
) -> UserRead:
    updated = await UserService(db, storage).upload_avatar(user, file)
    return UserRead.model_validate(updated)


@router.get("/{user_id}", response_model=UserRead)
async def get_user(user_id: str, db: DbSession, storage: Storage) -> UserRead:
    user = await UserService(db, storage).get_by_id(user_id)
    return UserRead.model_validate(user)
