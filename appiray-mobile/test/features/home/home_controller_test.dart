import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:appiray/core/utils/result.dart';
import 'package:appiray/features/home/data/courses_repository_impl.dart';
import 'package:appiray/features/home/domain/course_entities.dart';
import 'package:appiray/features/home/domain/courses_repository.dart';
import 'package:appiray/features/home/presentation/controllers/home_controller.dart';
import 'package:appiray/features/lesson_player/data/progress_repository_impl.dart';
import 'package:appiray/features/lesson_player/domain/lesson_entities.dart';
import 'package:appiray/features/lesson_player/domain/progress_repository.dart';

class MockCoursesRepository extends Mock implements CoursesRepository {}

class MockProgressRepository extends Mock implements ProgressRepository {}

void main() {
  late MockCoursesRepository courses;
  late MockProgressRepository progress;

  const detail = CourseDetail(
    id: 'c1',
    title: 'Malagasy 101',
    units: [
      CourseUnit(
        id: 'u1',
        courseId: 'c1',
        title: 'Unité 1',
        order: 0,
        lessons: [
          Lesson(id: 'l1', unitId: 'u1', title: 'Leçon 1', order: 0, xpReward: 20),
          Lesson(id: 'l2', unitId: 'u1', title: 'Leçon 2', order: 1, xpReward: 20),
        ],
      ),
    ],
  );

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [
        coursesRepositoryProvider.overrideWithValue(courses),
        progressRepositoryProvider.overrideWithValue(progress),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    courses = MockCoursesRepository();
    progress = MockProgressRepository();
    when(() => courses.listCourses()).thenAnswer(
      (_) async => const Result.success([Course(id: 'c1', title: 'Malagasy 101')]),
    );
    when(() => courses.getCourseDetail('c1'))
        .thenAnswer((_) async => const Result.success(detail));
  });

  test('première leçon débloquée, suivante verrouillée quand rien complété',
      () async {
    when(() => progress.listProgress())
        .thenAnswer((_) async => const Result.success(<LessonProgress>[]));

    final container = makeContainer();
    final state = await container.read(homeControllerProvider.future);

    expect(state.selectedCourse, isNotNull);
    expect(state.statusFor('l1'), LessonUiStatus.available);
    expect(state.statusFor('l2'), LessonUiStatus.locked);
  });

  test('leçon suivante débloquée quand la précédente est complétée', () async {
    when(() => progress.listProgress()).thenAnswer(
      (_) async => const Result.success([
        LessonProgress(
          lessonId: 'l1',
          status: ProgressStatus.completed,
          score: 100,
        ),
      ]),
    );

    final container = makeContainer();
    final state = await container.read(homeControllerProvider.future);

    expect(state.statusFor('l1'), LessonUiStatus.completed);
    expect(state.statusFor('l2'), LessonUiStatus.available);
  });
}
