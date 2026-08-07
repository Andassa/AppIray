from pydantic import BaseModel, ConfigDict, Field

from app.core.enums import ExerciseType


class CourseCreate(BaseModel):
    title: str = Field(min_length=1, max_length=200)
    description: str | None = None
    target_language: str = "malagasy"
    source_language: str = "français"


class CourseUpdate(BaseModel):
    title: str | None = None
    description: str | None = None
    target_language: str | None = None
    source_language: str | None = None


class CourseRead(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    title: str
    description: str | None
    target_language: str
    source_language: str


class UnitCreate(BaseModel):
    title: str
    order: int


class UnitRead(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    course_id: str
    title: str
    order: int


class LessonCreate(BaseModel):
    title: str
    order: int
    xp_reward: int = 20


class LessonRead(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    unit_id: str
    title: str
    order: int
    xp_reward: int


class ExerciseCreate(BaseModel):
    type: ExerciseType
    content: dict
    correct_answer: str
    audio_asset_id: str | None = None
    order: int = 0


class ExerciseRead(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    lesson_id: str
    type: ExerciseType
    content: dict
    audio_asset_id: str | None
    order: int


class LessonDetail(LessonRead):
    exercises: list[ExerciseRead] = []


class UnitDetail(UnitRead):
    lessons: list[LessonRead] = []


class CourseDetail(CourseRead):
    units: list[UnitDetail] = []
