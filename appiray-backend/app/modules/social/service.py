from fastapi import HTTPException, status
from sqlalchemy import or_, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.enums import FriendshipStatus, NotificationType
from app.modules.notifications.models import Notification
from app.modules.social.models import Friendship
from app.modules.social.schemas import FriendLeaderboardEntry, UserSearchResult
from app.modules.users.models import User


class SocialService:
    def __init__(self, db: AsyncSession) -> None:
        self.db = db

    async def request_friend(self, user: User, friend_id: str) -> Friendship:
        if friend_id == user.id:
            raise HTTPException(status_code=400, detail="Cannot friend yourself")
        friend = await self.db.get(User, friend_id)
        if friend is None:
            raise HTTPException(status_code=404, detail="User not found")

        existing = await self.db.execute(
            select(Friendship).where(
                or_(
                    (Friendship.user_id == user.id) & (Friendship.friend_id == friend_id),
                    (Friendship.user_id == friend_id) & (Friendship.friend_id == user.id),
                )
            )
        )
        if existing.scalar_one_or_none():
            raise HTTPException(status_code=409, detail="Friendship already exists")

        friendship = Friendship(
            user_id=user.id,
            friend_id=friend_id,
            status=FriendshipStatus.PENDING,
        )
        self.db.add(friendship)
        self.db.add(
            Notification(
                user_id=friend_id,
                type=NotificationType.FRIEND_REQUEST,
                payload={"from_user_id": user.id, "username": user.username},
            )
        )
        await self.db.commit()
        await self.db.refresh(friendship)
        return friendship

    async def accept_friend(self, user: User, friendship_id: str) -> Friendship:
        friendship = await self.db.get(Friendship, friendship_id)
        if friendship is None or friendship.friend_id != user.id:
            raise HTTPException(status_code=404, detail="Friend request not found")
        if friendship.status != FriendshipStatus.PENDING:
            raise HTTPException(status_code=400, detail="Request already handled")
        friendship.status = FriendshipStatus.ACCEPTED
        await self.db.commit()
        await self.db.refresh(friendship)
        return friendship

    async def list_friends(self, user_id: str) -> list[Friendship]:
        result = await self.db.execute(
            select(Friendship).where(
                Friendship.status == FriendshipStatus.ACCEPTED,
                or_(Friendship.user_id == user_id, Friendship.friend_id == user_id),
            )
        )
        return list(result.scalars().all())

    async def search_users(
        self, user: User, query: str, limit: int = 20
    ) -> list[UserSearchResult]:
        result = await self.db.execute(
            select(User)
            .where(User.username.ilike(f"%{query}%"), User.id != user.id)
            .order_by(User.username)
            .limit(limit)
        )
        found = list(result.scalars().all())
        if not found:
            return []

        found_ids = [u.id for u in found]
        rel_result = await self.db.execute(
            select(Friendship).where(
                or_(
                    (Friendship.user_id == user.id)
                    & (Friendship.friend_id.in_(found_ids)),
                    (Friendship.friend_id == user.id)
                    & (Friendship.user_id.in_(found_ids)),
                )
            )
        )
        status_by_user: dict[str, str] = {}
        for fr in rel_result.scalars().all():
            other_id = fr.friend_id if fr.user_id == user.id else fr.user_id
            status_by_user[other_id] = fr.status.value

        return [
            UserSearchResult(
                user_id=u.id,
                username=u.username,
                avatar_url=u.avatar_url,
                xp_total=u.xp_total,
                friendship_status=status_by_user.get(u.id, "none"),
            )
            for u in found
        ]

    async def friends_leaderboard(self, user: User) -> list[FriendLeaderboardEntry]:
        friendships = await self.list_friends(user.id)
        friend_ids = {
            f.friend_id if f.user_id == user.id else f.user_id for f in friendships
        }
        friend_ids.add(user.id)
        result = await self.db.execute(
            select(User).where(User.id.in_(friend_ids)).order_by(User.xp_total.desc())
        )
        users = list(result.scalars().all())
        return [
            FriendLeaderboardEntry(
                user_id=u.id,
                username=u.username,
                xp_total=u.xp_total,
                rank=idx + 1,
            )
            for idx, u in enumerate(users)
        ]
