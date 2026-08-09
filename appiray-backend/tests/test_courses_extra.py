import pytest
from app.core.enums import ExerciseType, UserRole
from app.modules.courses.models import Course, Exercise, Lesson, Unit
from httpx import AsyncClient
from sqlalchemy.ext.asyncio import AsyncSession

from tests.helpers import auth, create_user, login


async def _seed_course(db: AsyncSession) -> dict:
    course = Course(title="Malagasy 1", description="Intro")
    db.add(course)
    await db.flush()
    unit1 = Unit(course_id=course.id, title="Unit 1", order=1)
    unit2 = Unit(course_id=course.id, title="Unit 2", order=2)
    db.add_all([unit1, unit2])
    await db.flush()
    l1 = Lesson(unit_id=unit1.id, title="L1", order=1, xp_reward=20)
    l2 = Lesson(unit_id=unit1.id, title="L2", order=2, xp_reward=20)
    l3 = Lesson(unit_id=unit2.id, title="L3", order=1, xp_reward=20)
    db.add_all([l1, l2, l3])
    await db.flush()
    e1 = Exercise(
        lesson_id=l1.id, type=ExerciseType.TRANSLATE, content={}, correct_answer="a", order=1
    )
    e3 = Exercise(
        lesson_id=l3.id, type=ExerciseType.TRANSLATE, content={}, correct_answer="c", order=1
    )
    db.add_all([e1, e3])
    await db.commit()
    return {"course": course.id, "l1": l1.id, "l2": l2.id, "l3": l3.id, "e1": e1.id}


@pytest.mark.asyncio
async def test_lesson_lock_and_unlock(client: AsyncClient, db_session: AsyncSession) -> None:
    ids = await _seed_course(db_session)
    await create_user(db_session, email="lock@example.com", username="locker")
    token = await login(client, email="lock@example.com")

    # First lesson of first unit is always accessible.
    first = await client.get(f"/api/v1/courses/lessons/{ids['l1']}", headers=auth(token))
    assert first.status_code == 200

    # Second lesson is locked until L1 is completed.
    locked = await client.get(f"/api/v1/courses/lessons/{ids['l2']}", headers=auth(token))
    assert locked.status_code == 403

    # Complete L1 by answering its only exercise correctly.
    await client.post(
        "/api/v1/progress/answer",
        headers=auth(token),
        json={"exercise_id": ids["e1"], "answer": "a"},
    )
    unlocked = await client.get(f"/api/v1/courses/lessons/{ids['l2']}", headers=auth(token))
    assert unlocked.status_code == 200


@pytest.mark.asyncio
async def test_placement_test(client: AsyncClient, db_session: AsyncSession) -> None:
    ids = await _seed_course(db_session)
    await create_user(db_session, email="place@example.com", username="placer")
    token = await login(client, email="place@example.com")

    test = await client.get(f"/api/v1/courses/{ids['course']}/placement-test", headers=auth(token))
    assert test.status_code == 200
    exercises = test.json()
    assert len(exercises) == 2  # one representative per unit

    # Answer the first unit's exercise correctly, second one wrong → unlock 1 unit.
    answers = [
        {"exercise_id": ids["e1"], "answer": "a"},
        {"exercise_id": ids["l3"], "answer": "wrong"},  # bogus id counts as wrong
    ]
    submit = await client.post(
        f"/api/v1/courses/{ids['course']}/placement-test/submit",
        headers=auth(token),
        json={"answers": answers},
    )
    assert submit.status_code == 200, submit.text
    assert submit.json()["correct_count"] == 1
    assert submit.json()["units_unlocked"] == 1

    # Because unit 1 is now completed, the first lesson of unit 2 is unlocked.
    l3 = await client.get(f"/api/v1/courses/lessons/{ids['l3']}", headers=auth(token))
    assert l3.status_code == 200


@pytest.mark.asyncio
async def test_course_crud_nominal(client: AsyncClient, db_session: AsyncSession) -> None:
    await create_user(db_session, email="admin@example.com", username="admin", role=UserRole.ADMIN)
    token = await login(client, email="admin@example.com")

    created = await client.post(
        "/api/v1/courses",
        headers=auth(token),
        json={"title": "New Course", "description": "d"},
    )
    assert created.status_code == 201, created.text
    course_id = created.json()["id"]

    listing = await client.get("/api/v1/courses", headers=auth(token))
    assert listing.status_code == 200
    assert any(c["id"] == course_id for c in listing.json())
