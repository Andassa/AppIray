import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:appiray/core/utils/result.dart';
import 'package:appiray/features/lesson_player/data/progress_repository_impl.dart';
import 'package:appiray/features/lesson_player/domain/lesson_entities.dart';
import 'package:appiray/features/lesson_player/presentation/controllers/lesson_session_controller.dart';

part 'practice_controller.g.dart';

/// Session de révision. Réutilise [LessonSessionState] et les widgets
/// d'exercice de lesson_player. La pratique ne consomme pas de cœur.
@riverpod
class PracticeController extends _$PracticeController {
  @override
  Future<LessonSessionState> build() async {
    final repo = ref.read(progressRepositoryProvider);
    final result = await repo.getPracticeExercises();

    final exercises = switch (result) {
      Success<List<Exercise>>(:final value) => value,
      FailureResult<List<Exercise>>(:final failure) =>
        throw Exception(failure.message),
    };

    return LessonSessionState(
      lessonTitle: 'Révision',
      xpReward: 0,
      exercises: exercises,
      currentIndex: 0,
      heartsRemaining: 0,
      correctCount: 0,
      xpGained: 0,
      phase: exercises.isEmpty
          ? SessionPhase.finished
          : SessionPhase.playing,
      practice: true,
    );
  }

  Future<void> submitAnswer(String answer) async {
    final current = state.valueOrNull;
    if (current == null ||
        current.submitting ||
        current.phase != SessionPhase.playing) {
      return;
    }
    final exercise = current.currentExercise;
    if (exercise == null) return;

    state = AsyncData(current.copyWith(submitting: true));

    final result = await ref.read(progressRepositoryProvider).submitAnswer(
          exerciseId: exercise.id,
          answer: answer,
          practice: true,
        );

    switch (result) {
      case Success<AnswerOutcome>(:final value):
        state = AsyncData(current.copyWith(
          submitting: false,
          phase: SessionPhase.feedback,
          correctCount: value.isCorrect
              ? current.correctCount + 1
              : current.correctCount,
          xpGained: current.xpGained + value.xpGained,
          lastOutcome: value,
        ));
      case FailureResult<AnswerOutcome>(:final failure):
        state = AsyncError(failure, StackTrace.current);
        state = AsyncData(current.copyWith(submitting: false));
    }
  }

  void next() {
    final current = state.valueOrNull;
    if (current == null) return;
    if (current.isLast) {
      state = AsyncData(current.copyWith(phase: SessionPhase.finished));
    } else {
      state = AsyncData(current.copyWith(
        currentIndex: current.currentIndex + 1,
        phase: SessionPhase.playing,
      ));
    }
  }
}
