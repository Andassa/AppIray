import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:appiray/core/utils/result.dart';
import 'package:appiray/features/lesson_player/domain/lesson_entities.dart';
import 'package:appiray/features/placement_test/data/placement_repository_impl.dart';
import 'package:appiray/features/placement_test/domain/placement_entities.dart';

part 'placement_test_controller.g.dart';

/// Phase de la session de test de positionnement (pas de cœurs / XP).
enum PlacementPhase { answering, submitting, done }

/// État immuable d'une session de placement test.
class PlacementSessionState {
  const PlacementSessionState({
    required this.courseId,
    required this.exercises,
    required this.currentIndex,
    required this.answers,
    required this.phase,
    this.result,
    this.submitError,
  });

  final String courseId;
  final List<Exercise> exercises;
  final int currentIndex;
  final Map<String, String> answers;
  final PlacementPhase phase;
  final PlacementResult? result;
  final String? submitError;

  Exercise? get currentExercise =>
      currentIndex < exercises.length ? exercises[currentIndex] : null;

  int get total => exercises.length;
  bool get isLast =>
      exercises.isNotEmpty && currentIndex >= exercises.length - 1;
  int get answeredCount => answers.length;

  PlacementSessionState copyWith({
    int? currentIndex,
    Map<String, String>? answers,
    PlacementPhase? phase,
    PlacementResult? result,
    String? submitError,
    bool clearSubmitError = false,
  }) {
    return PlacementSessionState(
      courseId: courseId,
      exercises: exercises,
      currentIndex: currentIndex ?? this.currentIndex,
      answers: answers ?? this.answers,
      phase: phase ?? this.phase,
      result: result ?? this.result,
      submitError:
          clearSubmitError ? null : (submitError ?? this.submitError),
    );
  }
}

/// Contrôleur de session pour un cours donné (`courseId`).
@riverpod
class PlacementTestController extends _$PlacementTestController {
  @override
  Future<PlacementSessionState> build(String courseId) async {
    final repo = ref.read(placementRepositoryProvider);
    final result = await repo.getExercises(courseId);
    final exercises = switch (result) {
      Success<List<Exercise>>(:final value) => value,
      FailureResult<List<Exercise>>(:final failure) =>
        throw Exception(failure.message),
    };

    return PlacementSessionState(
      courseId: courseId,
      exercises: exercises,
      currentIndex: 0,
      answers: const {},
      phase: PlacementPhase.answering,
    );
  }

  /// Enregistre la réponse courante puis passe à la suivante, ou soumet
  /// le test si c'était la dernière question.
  Future<void> submitCurrentAnswer(String answer) async {
    final current = state.valueOrNull;
    if (current == null || current.phase != PlacementPhase.answering) {
      return;
    }
    final exercise = current.currentExercise;
    if (exercise == null) return;

    final updatedAnswers = Map<String, String>.from(current.answers)
      ..[exercise.id] = answer;

    if (!current.isLast) {
      state = AsyncData(
        current.copyWith(
          answers: updatedAnswers,
          currentIndex: current.currentIndex + 1,
          clearSubmitError: true,
        ),
      );
      return;
    }

    state = AsyncData(
      current.copyWith(
        answers: updatedAnswers,
        phase: PlacementPhase.submitting,
        clearSubmitError: true,
      ),
    );

    final repo = ref.read(placementRepositoryProvider);
    final submitResult = await repo.submit(
      courseId: current.courseId,
      answers: updatedAnswers,
    );

    final latest = state.valueOrNull ?? current;
    switch (submitResult) {
      case Success<PlacementResult>(:final value):
        state = AsyncData(
          latest.copyWith(
            answers: updatedAnswers,
            phase: PlacementPhase.done,
            result: value,
            clearSubmitError: true,
          ),
        );
      case FailureResult<PlacementResult>(:final failure):
        state = AsyncData(
          latest.copyWith(
            answers: updatedAnswers,
            phase: PlacementPhase.answering,
            submitError: failure.message,
          ),
        );
    }
  }
}
