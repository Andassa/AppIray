import pytest
from httpx import AsyncClient
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.enums import ExerciseType
from app.modules.courses.models import Course, Exercise, Lesson, Unit
from tests.helpers import auth, create_user, login


async def _seed_exercise(db: AsyncSession, *, correct: str = "salama") -> Exercise:
    course = Course(title="Malagasy 1", description="Intro")
    db.add(course)
    await db.flush()
    unit = Unit(course_id=course.id, title="Unit 1", order=1)
    db.add(unit)
    await db.flush()
    lesson = Lesson(unit_id=unit.id, title="Greetings", order=1, xp_reward=20)
    db.add(lesson)
    await db.flush()
    exercise = Exercise(
        lesson_id=lesson.id,
        type=ExerciseType.TRANSLATE,
        content={"prompt": "Bonjour"},
        correct_answer=correct,
        order=1,
    )
    db.add(exercise)
    await db.commit()
    await db.refresh(exercise)
    return exercise


@pytest.mark.asyncio
async def test_wrong_answer_arms_refill_and_gems_refill(
    client: AsyncClient, db_session: AsyncSession
) -> None:
    await create_user(
        db_session, email="econ@example.com", username="econ", gems=1000
    )
    exercise = await _seed_exercise(db_session)
    token = await login(client, email="econ@example.com")

    wrong = await client.post(
        "/api/v1/progress/answer",
        headers=auth(token),
        json={"exercise_id": exercise.id, "answer": "nope"},
    )
    assert wrong.status_code == 200
    assert wrong.json()["hearts"] == 4

    status = await client.get("/api/v1/progress/hearts", headers=auth(token))
    assert status.status_code == 200
    body = status.json()
    assert body["hearts"] == 4
    assert body["heart_refill_at"] is not None

    refill = await client.post(
        "/api/v1/progress/hearts/refill-with-gems", headers=auth(token)
    )
    assert refill.status_code == 200, refill.text
    assert refill.json()["hearts"] == body["max_hearts"]
    assert refill.json()["heart_refill_at"] is None
    assert refill.json()["gems"] == 1000 - 350  # GEM_COST_HEART_REFILL default


@pytest.mark.asyncio
async def test_refill_with_gems_requires_missing_hearts(
    client: AsyncClient, db_session: AsyncSession
) -> None:
    await create_user(db_session, email="full@example.com", username="fullhearts", gems=1000)
    token = await login(client, email="full@example.com")
    resp = await client.post(
        "/api/v1/progress/hearts/refill-with-gems", headers=auth(token)
    )
    assert resp.status_code == 400


@pytest.mark.asyncio
async def test_streak_freeze_purchase(
    client: AsyncClient, db_session: AsyncSession
) -> None:
    await create_user(db_session, email="freeze@example.com", username="freezer", gems=1000)
    token = await login(client, email="freeze@example.com")

    resp = await client.post("/api/v1/progress/streak/freeze", headers=auth(token))
    assert resp.status_code == 201, resp.text
    assert resp.json()["used"] is False

    # A second active freeze is refused.
    resp2 = await client.post("/api/v1/progress/streak/freeze", headers=auth(token))
    assert resp2.status_code == 409


@pytest.mark.asyncio
async def test_streak_freeze_insufficient_gems(
    client: AsyncClient, db_session: AsyncSession
) -> None:
    await create_user(db_session, email="poor@example.com", username="poor", gems=0)
    token = await login(client, email="poor@example.com")
    resp = await client.post("/api/v1/progress/streak/freeze", headers=auth(token))
    assert resp.status_code == 400


@pytest.mark.asyncio
async def test_update_daily_goal(
    client: AsyncClient, db_session: AsyncSession
) -> None:
    await create_user(db_session, email="goal@example.com", username="goalie")
    token = await login(client, email="goal@example.com")
    resp = await client.patch(
        "/api/v1/progress/daily-goal", headers=auth(token), json={"daily_xp_goal": 50}
    )
    assert resp.status_code == 200
    assert resp.json()["daily_xp_goal"] == 50

    me = await client.get("/api/v1/users/me", headers=auth(token))
    assert me.json()["daily_xp_goal"] == 50


@pytest.mark.asyncio
async def test_practice_mode_no_heart_cost(
    client: AsyncClient, db_session: AsyncSession
) -> None:
    await create_user(db_session, email="prac@example.com", username="practicer")
    exercise = await _seed_exercise(db_session)
    token = await login(client, email="prac@example.com")

    # Get it wrong once so it qualifies for practice selection.
    await client.post(
        "/api/v1/progress/answer",
        headers=auth(token),
        json={"exercise_id": exercise.id, "answer": "wrong"},
    )

    practice = await client.get("/api/v1/progress/practice", headers=auth(token))
    assert practice.status_code == 200
    ids = [e["id"] for e in practice.json()]
    assert exercise.id in ids

    me_before = await client.get("/api/v1/progress/hearts", headers=auth(token))
    hearts_before = me_before.json()["hearts"]

    # A wrong practice answer must NOT cost a heart.
    prac_answer = await client.post(
        "/api/v1/progress/answer",
        headers=auth(token),
        json={"exercise_id": exercise.id, "answer": "wrong-again", "practice": True},
    )
    assert prac_answer.status_code == 200
    assert prac_answer.json()["hearts"] == hearts_before

    # A correct practice answer grants small XP without lesson completion.
    prac_ok = await client.post(
        "/api/v1/progress/answer",
        headers=auth(token),
        json={"exercise_id": exercise.id, "answer": "salama", "practice": True},
    )
    assert prac_ok.status_code == 200
    assert prac_ok.json()["is_correct"] is True
    assert prac_ok.json()["xp_gained"] == 5  # PRACTICE_XP_REWARD default
    assert prac_ok.json()["lesson_completed"] is False
