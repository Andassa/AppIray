import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:appiray/core/utils/result.dart';
import 'package:appiray/features/home/data/courses_repository_impl.dart';
import 'package:appiray/features/home/domain/course_entities.dart';
import 'package:appiray/features/lesson_player/data/progress_repository_impl.dart';
import 'package:appiray/features/lesson_player/domain/lesson_entities.dart';

part 'home_controller.g.dart';

/// État de l'accueil : cours disponibles, cours sélectionné (détaillé) et
/// statut d'affichage calculé pour chaque leçon.
class HomeState {
  const HomeState({
    required this.courses,
    required this.selectedCourse,
    required this.lessonStatuses,
  });

  final List<Course> courses;
  final CourseDetail? selectedCourse;
  final Map<String, LessonUiStatus> lessonStatuses;

  LessonUiStatus statusFor(String lessonId) =>
      lessonStatuses[lessonId] ?? LessonUiStatus.locked;
}

@riverpod
class HomeController extends _$HomeController {
  @override
  Future<HomeState> build() async {
    final coursesRepo = ref.read(coursesRepositoryProvider);
    final coursesResult = await coursesRepo.listCourses();

    final courses = switch (coursesResult) {
      Success<List<Course>>(:final value) => value,
      FailureResult<List<Course>>(:final failure) =>
        throw Exception(failure.message),
    };

    if (courses.isEmpty) {
      return const HomeState(
        courses: [],
        selectedCourse: null,
        lessonStatuses: {},
      );
    }

    return _loadCourse(courses, courses.first.id);
  }

  /// Change le cours sélectionné et recalcule les statuts.
  Future<void> selectCourse(String courseId) async {
    final current = state.valueOrNull;
    if (current == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _loadCourse(current.courses, courseId),
    );
  }

  Future<HomeState> _loadCourse(List<Course> courses, String courseId) async {
    final coursesRepo = ref.read(coursesRepositoryProvider);
    final progressRepo = ref.read(progressRepositoryProvider);

    final detailResult = await coursesRepo.getCourseDetail(courseId);
    final detail = switch (detailResult) {
      Success<CourseDetail>(:final value) => value,
      FailureResult<CourseDetail>(:final failure) =>
        throw Exception(failure.message),
    };

    // Progression : best-effort (on affiche verrouillé par défaut si indispo).
    final progressResult = await progressRepo.listProgress();
    final progress = progressResult.valueOrNull ?? const <LessonProgress>[];

    return HomeState(
      courses: courses,
      selectedCourse: detail,
      lessonStatuses: _computeStatuses(detail, progress),
    );
  }

  /// Calcule le statut de chaque leçon.
  ///
  /// Règle d'unlock (miroir du backend) : une leçon est jouable si c'est la
  /// première du parcours OU si la précédente est complétée.
  Map<String, LessonUiStatus> _computeStatuses(
    CourseDetail detail,
    List<LessonProgress> progress,
  ) {
    final byLesson = {for (final p in progress) p.lessonId: p.status};

    final flat = <Lesson>[
      for (final unit in detail.units) ...unit.lessons,
    ];

    final statuses = <String, LessonUiStatus>{};
    var previousCompleted = true; // la première leçon est débloquée
    for (final lesson in flat) {
      final status = byLesson[lesson.id];
      final LessonUiStatus ui;
      if (status == ProgressStatus.completed) {
        ui = LessonUiStatus.completed;
      } else if (status == ProgressStatus.inProgress) {
        ui = LessonUiStatus.inProgress;
      } else if (previousCompleted) {
        ui = LessonUiStatus.available;
      } else {
        ui = LessonUiStatus.locked;
      }
      statuses[lesson.id] = ui;
      previousCompleted = status == ProgressStatus.completed;
    }
    return statuses;
  }
}
