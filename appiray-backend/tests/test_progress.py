import pytest
from httpx import AsyncClient
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.enums import ExerciseType, UserRole
from app.core.security import hash_password
from app.modules.courses.models import Course, Exercise, Lesson, Unit
from app.modules.users.models import User


async def _seed_lesson(db: AsyncSession) -> tuple[User, Exercise]:
    user = User(
        email="xp@example.com",
        username="xpuser",
        hashed_password=hash_password("securepass1"),
        role=UserRole.USER,
        hearts=5,
    )
    course = Course(title="Malagasy 1", description="Intro")
    db.add_all([user, course])
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
        correct_answer="Salama",
        order=1,
    )
    db.add(exercise)
    await db.commit()
    await db.refresh(user)
    await db.refresh(exercise)
    return user, exercise


@pytest.mark.asyncio
async def test_submit_answer_awards_xp(
    client: AsyncClient, db_session: AsyncSession
) -> None:
    user, exercise = await _seed_lesson(db_session)

    login = await client.post(
        "/api/v1/auth/login",
        json={"email": "xp@example.com", "password": "securepass1"},
    )
    assert login.status_code == 200, login.text
    token = login.json()["access_token"]

    wrong = await client.post(
        "/api/v1/progress/answer",
        headers={"Authorization": f"Bearer {token}"},
        json={"exercise_id": exercise.id, "answer": "Wrong"},
    )
    assert wrong.status_code == 200
    assert wrong.json()["is_correct"] is False
    assert wrong.json()["hearts"] == 4
    assert wrong.json()["xp_gained"] == 0

    right = await client.post(
        "/api/v1/progress/answer",
        headers={"Authorization": f"Bearer {token}"},
        json={"exercise_id": exercise.id, "answer": "salama"},
    )
    assert right.status_code == 200, right.text
    assert right.json()["is_correct"] is True
    assert right.json()["xp_gained"] == 10
    assert right.json()["xp_total"] >= 10
    assert right.json()["lesson_completed"] is True
