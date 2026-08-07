import pytest
from httpx import AsyncClient
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.enums import ExerciseType
from app.modules.courses.models import Course, Exercise, Lesson, Unit
from tests.helpers import auth, create_user, login


async def _seed_exercise(db: AsyncSession) -> Exercise:
    course = Course(title="C", description="d")
    db.add(course)
    await db.flush()
    unit = Unit(course_id=course.id, title="U", order=1)
    db.add(unit)
    await db.flush()
    lesson = Lesson(unit_id=unit.id, title="L", order=1, xp_reward=20)
    db.add(lesson)
    await db.flush()
    exercise = Exercise(
        lesson_id=lesson.id,
        type=ExerciseType.TRANSLATE,
        content={},
        correct_answer="salama",
        order=1,
    )
    db.add(exercise)
    await db.commit()
    await db.refresh(exercise)
    return exercise


@pytest.mark.asyncio
async def test_daily_quests_generated_and_progress(
    client: AsyncClient, db_session: AsyncSession
) -> None:
    await create_user(db_session, email="quest@example.com", username="quester")
    exercise = await _seed_exercise(db_session)
    token = await login(client, email="quest@example.com")

    # First call generates today's quests from the pool.
    quests = await client.get("/api/v1/gamification/quests/me", headers=auth(token))
    assert quests.status_code == 200
    data = quests.json()
    assert len(data) == 3
    assert all(q["progress"] == 0 for q in data)

    # A correct answer advances the XP / perfect-answer quests.
    answer = await client.post(
        "/api/v1/progress/answer",
        headers=auth(token),
        json={"exercise_id": exercise.id, "answer": "salama"},
    )
    assert answer.status_code == 200

    quests2 = await client.get("/api/v1/gamification/quests/me", headers=auth(token))
    progresses = {q["quest"]["criteria"]["type"]: q["progress"] for q in quests2.json()}
    assert progresses["perfect_answer"] >= 1
    assert progresses["xp_earned"] >= 10
