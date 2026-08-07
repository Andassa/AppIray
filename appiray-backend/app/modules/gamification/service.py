from datetime import UTC, date, datetime, timedelta

from fastapi import HTTPException
from redis.asyncio import Redis
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.core.enums import NotificationType
from app.modules.gamification.models import Badge, League, LeagueMembership, UserBadge
from app.modules.gamification.schemas import BadgeCreate, LeaderboardEntry
from app.modules.notifications.models import Notification
from app.modules.users.models import User

TIER_NAMES = {
    1: "Bronze",
    2: "Silver",
    3: "Gold",
    4: "Sapphire",
    5: "Ruby",
    6: "Emerald",
    7: "Amethyst",
    8: "Pearl",
    9: "Obsidian",
    10: "Diamond",
}


def _week_bounds(ref: date | None = None) -> tuple[date, date]:
    today = ref or datetime.now(UTC).date()
    start = today - timedelta(days=today.weekday())
    end = start + timedelta(days=6)
    return start, end


class GamificationService:
    def __init__(self, db: AsyncSession, redis: Redis | None = None) -> None:
        self.db = db
        self.redis = redis

    def _leaderboard_key(self, league_id: str) -> str:
        return f"league:{league_id}:lb"

    async def ensure_membership(self, user: User, tier: int = 1) -> LeagueMembership:
        week_start, week_end = _week_bounds()
        result = await self.db.execute(
            select(League).where(League.tier == tier, League.week_start == week_start)
        )
        league = result.scalar_one_or_none()
        if league is None:
            league = League(
                name=f"{TIER_NAMES.get(tier, f'Tier {tier}')} League",
                tier=tier,
                week_start=week_start,
                week_end=week_end,
            )
            self.db.add(league)
            await self.db.flush()

        mem_result = await self.db.execute(
            select(LeagueMembership).where(
                LeagueMembership.league_id == league.id,
                LeagueMembership.user_id == user.id,
            )
        )
        membership = mem_result.scalar_one_or_none()
        if membership is None:
            membership = LeagueMembership(league_id=league.id, user_id=user.id, xp_this_week=0)
            self.db.add(membership)
            await self.db.flush()
            if self.redis:
                await self.redis.zadd(self._leaderboard_key(league.id), {user.id: 0})
        return membership

    async def add_weekly_xp(self, user: User, amount: int) -> None:
        if amount <= 0:
            return
        membership = await self.ensure_membership(user)
        membership.xp_this_week += amount
        if self.redis:
            await self.redis.zincrby(
                self._leaderboard_key(membership.league_id), amount, user.id
            )

    async def get_leaderboard(self, user: User, limit: int = 50) -> list[LeaderboardEntry]:
        membership = await self.ensure_membership(user)
        await self.db.commit()

        if self.redis:
            rows = await self.redis.zrevrange(
                self._leaderboard_key(membership.league_id), 0, limit - 1, withscores=True
            )
            user_ids = [uid for uid, _ in rows]
            if not user_ids:
                return []
            users = await self.db.execute(select(User).where(User.id.in_(user_ids)))
            by_id = {u.id: u for u in users.scalars().all()}
            return [
                LeaderboardEntry(
                    user_id=uid,
                    username=by_id[uid].username if uid in by_id else "unknown",
                    xp_this_week=int(score),
                    rank=idx + 1,
                )
                for idx, (uid, score) in enumerate(rows)
            ]

        result = await self.db.execute(
            select(LeagueMembership, User)
            .join(User, User.id == LeagueMembership.user_id)
            .where(LeagueMembership.league_id == membership.league_id)
            .order_by(LeagueMembership.xp_this_week.desc())
            .limit(limit)
        )
        return [
            LeaderboardEntry(
                user_id=u.id,
                username=u.username,
                xp_this_week=m.xp_this_week,
                rank=idx + 1,
            )
            for idx, (m, u) in enumerate(result.all())
        ]

    async def close_current_week(self) -> None:
        week_start, _ = _week_bounds()
        prev_start = week_start - timedelta(days=7)
        result = await self.db.execute(select(League).where(League.week_start == prev_start))
        leagues = list(result.scalars().all())
        for league in leagues:
            mems = await self.db.execute(
                select(LeagueMembership)
                .where(LeagueMembership.league_id == league.id)
                .order_by(LeagueMembership.xp_this_week.desc())
            )
            memberships = list(mems.scalars().all())
            promote_n = max(1, len(memberships) // 3) if memberships else 0
            for idx, membership in enumerate(memberships):
                user = await self.db.get(User, membership.user_id)
                if user is None:
                    continue
                new_tier = league.tier
                if idx < promote_n:
                    new_tier = min(league.tier + 1, 10)
                elif idx >= len(memberships) - promote_n:
                    new_tier = max(league.tier - 1, 1)
                await self.ensure_membership(user, tier=new_tier)
                self.db.add(
                    Notification(
                        user_id=user.id,
                        type=NotificationType.LEAGUE_RESULT,
                        payload={
                            "previous_tier": league.tier,
                            "new_tier": new_tier,
                            "rank": idx + 1,
                        },
                    )
                )
            if self.redis:
                await self.redis.delete(self._leaderboard_key(league.id))

    async def create_badge(self, data: BadgeCreate) -> Badge:
        badge = Badge(**data.model_dump())
        self.db.add(badge)
        await self.db.commit()
        await self.db.refresh(badge)
        return badge

    async def list_badges(self) -> list[Badge]:
        result = await self.db.execute(select(Badge).order_by(Badge.name))
        return list(result.scalars().all())

    async def list_user_badges(self, user_id: str) -> list[UserBadge]:
        result = await self.db.execute(
            select(UserBadge)
            .where(UserBadge.user_id == user_id)
            .options(selectinload(UserBadge.badge))
        )
        return list(result.scalars().all())

    async def check_badges(self, user: User) -> None:
        badges = await self.list_badges()
        owned = await self.db.execute(
            select(UserBadge.badge_id).where(UserBadge.user_id == user.id)
        )
        owned_ids = set(owned.scalars().all())
        for badge in badges:
            if badge.id in owned_ids:
                continue
            criteria = badge.criteria or {}
            min_xp = criteria.get("min_xp")
            min_streak = criteria.get("min_streak")
            ok = True
            if min_xp is not None and user.xp_total < min_xp:
                ok = False
            if min_streak is not None and user.longest_streak < min_streak:
                ok = False
            if ok and criteria:
                self.db.add(UserBadge(user_id=user.id, badge_id=badge.id))
                self.db.add(
                    Notification(
                        user_id=user.id,
                        type=NotificationType.BADGE_EARNED,
                        payload={"badge_id": badge.id, "name": badge.name},
                    )
                )

    async def current_league(self, user: User) -> League:
        membership = await self.ensure_membership(user)
        league = await self.db.get(League, membership.league_id)
        if league is None:
            raise HTTPException(status_code=404, detail="League not found")
        return league
