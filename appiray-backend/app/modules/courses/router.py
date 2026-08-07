from fastapi import APIRouter

from app.core.deps import CurrentAdmin, CurrentUser, DbSession
from app.modules.courses.schemas import (
    CourseCreate,
    CourseDetail,
    CourseRead,
    CourseUpdate,
    ExerciseCreate,
    ExerciseRead,
    LessonCreate,
    LessonDetail,
    LessonRead,
    UnitCreate,
    UnitRead,
)
from app.modules.courses.service import CourseService

router = APIRouter(prefix="/courses", tags=["courses"])


@router.get("", response_model=list[CourseRead])
async def list_courses(db: DbSession, _: CurrentUser) -> list[CourseRead]:
    courses = await CourseService(db).list_courses()
    return [CourseRead.model_validate(c) for c in courses]


@router.get("/{course_id}", response_model=CourseDetail)
async def get_course(course_id: str, db: DbSession, _: CurrentUser) -> CourseDetail:
    course = await CourseService(db).get_course(course_id)
    return CourseDetail.model_validate(course)


@router.post("", response_model=CourseRead, status_code=201)
async def create_course(
    data: CourseCreate, db: DbSession, _: CurrentAdmin
) -> CourseRead:
    course = await CourseService(db).create_course(data)
    return CourseRead.model_validate(course)


@router.patch("/{course_id}", response_model=CourseRead)
async def update_course(
    course_id: str, data: CourseUpdate, db: DbSession, _: CurrentAdmin
) -> CourseRead:
    course = await CourseService(db).update_course(course_id, data)
    return CourseRead.model_validate(course)


@router.post("/{course_id}/units", response_model=UnitRead, status_code=201)
async def create_unit(
    course_id: str, data: UnitCreate, db: DbSession, _: CurrentAdmin
) -> UnitRead:
    unit = await CourseService(db).create_unit(course_id, data)
    return UnitRead.model_validate(unit)


@router.post("/units/{unit_id}/lessons", response_model=LessonRead, status_code=201)
async def create_lesson(
    unit_id: str, data: LessonCreate, db: DbSession, _: CurrentAdmin
) -> LessonRead:
    lesson = await CourseService(db).create_lesson(unit_id, data)
    return LessonRead.model_validate(lesson)


@router.get("/lessons/{lesson_id}", response_model=LessonDetail)
async def get_lesson(lesson_id: str, db: DbSession, _: CurrentUser) -> LessonDetail:
    lesson = await CourseService(db).get_lesson(lesson_id)
    # Hide correct_answer from learners
    return LessonDetail(
        id=lesson.id,
        unit_id=lesson.unit_id,
        title=lesson.title,
        order=lesson.order,
        xp_reward=lesson.xp_reward,
        exercises=[
            ExerciseRead(
                id=e.id,
                lesson_id=e.lesson_id,
                type=e.type,
                content=e.content,
                audio_asset_id=e.audio_asset_id,
                order=e.order,
            )
            for e in sorted(lesson.exercises, key=lambda x: x.order)
        ],
    )


@router.post(
    "/lessons/{lesson_id}/exercises",
    response_model=ExerciseRead,
    status_code=201,
)
async def create_exercise(
    lesson_id: str, data: ExerciseCreate, db: DbSession, _: CurrentAdmin
) -> ExerciseRead:
    exercise = await CourseService(db).create_exercise(lesson_id, data)
    return ExerciseRead.model_validate(exercise)
