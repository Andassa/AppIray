from fastapi import HTTPException, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.modules.courses.models import Course, Exercise, Lesson, Unit
from app.modules.courses.schemas import (
    CourseCreate,
    CourseUpdate,
    ExerciseCreate,
    LessonCreate,
    UnitCreate,
)


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
