from datetime import UTC, datetime

from fastapi import HTTPException, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.core.enums import ProgressStatus
from app.modules.courses.models import Course, Exercise, Lesson, Unit
from app.modules.courses.schemas import (
    CourseCreate,
    CourseUpdate,
    ExerciseCreate,
    LessonCreate,
    UnitCreate,
)
from app.modules.progress.models import UserProgress


class CourseService:
    def __init__(self, db: AsyncSession) -> None:
        self.db = db

    async def list_courses(self) -> list[Course]:
        result = await self.db.execute(select(Course).order_by(Course.title))
        return list(result.scalars().all())

    async def get_course(self, course_id: str) -> Course:
        result = await self.db.execute(
            select(Course)
            .where(Course.id == course_id)
            .options(selectinload(Course.units).selectinload(Unit.lessons))
        )
        course = result.scalar_one_or_none()
        if course is None:
            raise HTTPException(status_code=404, detail="Course not found")
        return course

    async def create_course(self, data: CourseCreate) -> Course:
        course = Course(**data.model_dump())
        self.db.add(course)
        await self.db.commit()
        await self.db.refresh(course)
        return course

    async def update_course(self, course_id: str, data: CourseUpdate) -> Course:
        course = await self.get_course(course_id)
        for key, value in data.model_dump(exclude_unset=True).items():
            setattr(course, key, value)
        await self.db.commit()
        await self.db.refresh(course)
        return course

    async def create_unit(self, course_id: str, data: UnitCreate) -> Unit:
        await self.get_course(course_id)
        unit = Unit(course_id=course_id, **data.model_dump())
        self.db.add(unit)
        await self.db.commit()
        await self.db.refresh(unit)
        return unit

    async def create_lesson(self, unit_id: str, data: LessonCreate) -> Lesson:
        result = await self.db.execute(select(Unit).where(Unit.id == unit_id))
        if result.scalar_one_or_none() is None:
            raise HTTPException(status_code=404, detail="Unit not found")
        lesson = Lesson(unit_id=unit_id, **data.model_dump())
        self.db.add(lesson)
        await self.db.commit()
        await self.db.refresh(lesson)
        return lesson

    async def get_lesson(self, lesson_id: str) -> Lesson:
        result = await self.db.execute(
            select(Lesson)
            .where(Lesson.id == lesson_id)
            .options(selectinload(Lesson.exercises))
        )
        lesson = result.scalar_one_or_none()
        if lesson is None:
            raise HTTPException(status_code=404, detail="Lesson not found")
        return lesson

    async def create_exercise(self, lesson_id: str, data: ExerciseCreate) -> Exercise:
        await self.get_lesson(lesson_id)
        exercise = Exercise(lesson_id=lesson_id, **data.model_dump())
        self.db.add(exercise)
        await self.db.commit()
        await self.db.refresh(exercise)
        return exercise

    async def get_exercise(self, exercise_id: str) -> Exercise:
        result = await self.db.execute(select(Exercise).where(Exercise.id == exercise_id))
        exercise = result.scalar_one_or_none()
        if exercise is None:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND, detail="Exercise not found"
            )
        return exercise

    async def _completed_lesson_ids(self, user_id: str) -> set[str]:
        result = await self.db.execute(
            select(UserProgress.lesson_id).where(
                UserProgress.user_id == user_id,
                UserProgress.status == ProgressStatus.COMPLETED,
            )
        )
        return set(result.scalars().all())

    async def is_lesson_unlocked(self, user_id: str, lesson_id: str) -> bool:
        """A lesson is unlocked if the previous lesson in its unit is completed;
        the first lesson of a unit requires the previous unit to be fully
        completed. The very first lesson of the first unit is always unlocked.
        """
        lesson = await self.db.get(Lesson, lesson_id)
        if lesson is None:
            raise HTTPException(status_code=404, detail="Lesson not found")

        unit = await self.db.get(Unit, lesson.unit_id)
        if unit is None:
            raise HTTPException(status_code=404, detail="Unit not found")

        completed = await self._completed_lesson_ids(user_id)

        # Lessons of this unit, ordered.
        unit_lessons = (
            await self.db.execute(
                select(Lesson).where(Lesson.unit_id == unit.id).order_by(Lesson.order)
            )
        ).scalars().all()
        idx = next((i for i, le in enumerate(unit_lessons) if le.id == lesson.id), 0)

        if idx > 0:
            return unit_lessons[idx - 1].id in completed

        # First lesson of the unit → depends on the previous unit being complete.
        prev_unit = (
            await self.db.execute(
                select(Unit)
                .where(Unit.course_id == unit.course_id, Unit.order < unit.order)
                .order_by(Unit.order.desc())
                .limit(1)
            )
        ).scalar_one_or_none()
        if prev_unit is None:
            return True  # first unit, first lesson

        prev_lessons = (
            await self.db.execute(select(Lesson).where(Lesson.unit_id == prev_unit.id))
        ).scalars().all()
        if not prev_lessons:
            return True
        return all(le.id in completed for le in prev_lessons)

    async def placement_test_exercises(self, course_id: str) -> list[Exercise]:
        """One representative exercise per unit (first exercise of first lesson)."""
        course = await self.get_course(course_id)
        exercises: list[Exercise] = []
        for unit in sorted(course.units, key=lambda u: u.order):
            lessons = (
                await self.db.execute(
                    select(Lesson)
                    .where(Lesson.unit_id == unit.id)
                    .order_by(Lesson.order)
                    .options(selectinload(Lesson.exercises))
                )
            ).scalars().all()
            for lesson in lessons:
                ordered = sorted(lesson.exercises, key=lambda e: e.order)
                if ordered:
                    exercises.append(ordered[0])
                    break
        return exercises

    async def submit_placement_test(
        self, user_id: str, course_id: str, answers: dict[str, str]
    ) -> tuple[int, int]:
        """Grade a placement test and unlock units up to the detected level.

        MVP heuristic: units are ordered; the number of correctly answered
        representative exercises = number of units to mark completed. All
        lessons in those units get a COMPLETED UserProgress so the learner
        starts at the right place. Returns (correct_count, units_unlocked).
        """
        course = await self.get_course(course_id)
        ordered_units = sorted(course.units, key=lambda u: u.order)

        # Grade against stored correct answers.
        exercise_ids = list(answers.keys())
        graded_correct = 0
        if exercise_ids:
            rows = (
                await self.db.execute(
                    select(Exercise).where(Exercise.id.in_(exercise_ids))
                )
            ).scalars().all()
            by_id = {e.id: e for e in rows}
            for ex_id, given in answers.items():
                exercise = by_id.get(ex_id)
                if exercise and self._normalize(given) == self._normalize(
                    exercise.correct_answer
                ):
                    graded_correct += 1

        units_to_unlock = min(graded_correct, len(ordered_units))
        now = datetime.now(UTC)
        completed = await self._completed_lesson_ids(user_id)
        for unit in ordered_units[:units_to_unlock]:
            lessons = (
                await self.db.execute(select(Lesson).where(Lesson.unit_id == unit.id))
            ).scalars().all()
            for lesson in lessons:
                if lesson.id in completed:
                    continue
                self.db.add(
                    UserProgress(
                        user_id=user_id,
                        lesson_id=lesson.id,
                        status=ProgressStatus.COMPLETED,
                        score=100,
                        completed_at=now,
                    )
                )
        await self.db.commit()
        return graded_correct, units_to_unlock

    @staticmethod
    def _normalize(value: str) -> str:
        return " ".join(value.strip().lower().split())
