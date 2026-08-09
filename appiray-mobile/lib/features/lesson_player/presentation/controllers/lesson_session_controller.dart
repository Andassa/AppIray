import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:appiray/core/utils/result.dart';
import 'package:appiray/features/lesson_player/data/progress_repository_impl.dart';
import 'package:appiray/features/lesson_player/domain/lesson_entities.dart';

part 'lesson_session_controller.g.dart';

/// Phase courante de la session de leçon.
enum SessionPhase { playing, feedback, finished, gameOver }

/// État immuable d'une session de leçon en cours.
///
/// Toute la logique de session vit ici (via le controller), jamais dans le
/// widget : question courante, cœurs restants, score, feedback, fin de session.
class LessonSessionState {
  const LessonSessionState({
    required this.lessonTitle,
    required this.xpReward,
    required this.exercises,
    required this.currentIndex,
    required this.heartsRemaining,
    required this.correctCount,
    required this.xpGained,
    required this.phase,
    this.lastOutcome,
    this.submitting = false,
    this.practice = false,
  });

  final String lessonTitle;
  final int xpReward;
  final List<Exercise> exercises;
  final int currentIndex;
  final int heartsRemaining;
  final int correctCount;
  final int xpGained;
  final SessionPhase phase;

  /// Dernier résultat serveur (pour l'affichage du feedback).
  final AnswerOutcome? lastOutcome;
  final bool submitting;
  final bool practice;

  Exercise? get currentExercise =>
      currentIndex < exercises.length ? exercises[currentIndex] : null;

  int get total => exercises.length;
  bool get isLast => currentIndex >= exercises.length - 1;

  LessonSessionState copyWith({
    int? currentIndex,
    int? heartsRemaining,
    int? correctCount,
    int? xpGained,
    SessionPhase? phase,
    AnswerOutcome? lastOutcome,
    bool? submitting,
  }) {
    return LessonSessionState(
      lessonTitle: lessonTitle,
      xpReward: xpReward,
      exercises: exercises,
      currentIndex: currentIndex ?? this.currentIndex,
      heartsRemaining: heartsRemaining ?? this.heartsRemaining,
      correctCount: correctCount ?? this.correctCount,
      xpGained: xpGained ?? this.xpGained,
      phase: phase ?? this.phase,
      lastOutcome: lastOutcome ?? this.lastOutcome,
      submitting: submitting ?? this.submitting,
      practice: practice,
    );
  }
}

/// Contrôleur de session pour une leçon donnée (`lessonId`).
@riverpod
class LessonSessionController extends _$LessonSessionController {
  @override
  Future<LessonSessionState> build(String lessonId) async {
    final repo = ref.read(progressRepositoryProvider);

    final lessonResult = await repo.getLesson(lessonId);
    final lesson = switch (lessonResult) {
      Success<LessonContent>(:final value) => value,
      FailureResult<LessonContent>(:final failure) =>
        throw Exception(failure.message),
    };

    // Cœurs : best-effort, on n'échoue pas la session si l'appel foire.
    final heartsResult = await repo.getHearts();
    final hearts = heartsResult.valueOrNull?.hearts ?? 5;

    return LessonSessionState(
      lessonTitle: lesson.title,
      xpReward: lesson.xpReward,
      exercises: lesson.exercises,
      currentIndex: 0,
      heartsRemaining: hearts,
      correctCount: 0,
      xpGained: 0,
      phase: SessionPhase.playing,
    );
  }

  /// Soumet la réponse de l'exercice courant.
  ///
  /// - Optimistic update : on décrémente le cœur localement AVANT confirmation.
  /// - On resynchronise ensuite avec la valeur serveur (source de vérité).
  Future<void> submitAnswer(String answer) async {
    final current = state.valueOrNull;
    if (current == null ||
        current.submitting ||
        current.phase != SessionPhase.playing) {
      return;
    }
    final exercise = current.currentExercise;
    if (exercise == null) return;

    // Optimistic : on prépare une baisse de cœur potentielle côté UI.
    state = AsyncData(current.copyWith(submitting: true));

    final result = await ref.read(progressRepositoryProvider).submitAnswer(
          exerciseId: exercise.id,
          answer: answer,
          practice: current.practice,
        );

    switch (result) {
      case Success<AnswerOutcome>(:final value):
        final serverHearts = current.practice
            ? current.heartsRemaining // la pratique ne consomme pas de cœur
            : value.hearts;
        final next = current.copyWith(
          submitting: false,
          phase: serverHearts <= 0 && !current.practice
              ? SessionPhase.gameOver
              : SessionPhase.feedback,
          heartsRemaining: serverHearts,
          correctCount:
              value.isCorrect ? current.correctCount + 1 : current.correctCount,
          xpGained: current.xpGained + value.xpGained,
          lastOutcome: value,
        );
        state = AsyncData(next);
      case FailureResult<AnswerOutcome>(:final failure):
        // On repasse en "playing" pour permettre un nouvel essai, en
        // remontant l'erreur via AsyncError transitoire.
        state = AsyncError(failure, StackTrace.current);
        state = AsyncData(current.copyWith(submitting: false));
    }
  }

  /// Passe à l'exercice suivant (ou termine la session).
  void next() {
    final current = state.valueOrNull;
    if (current == null || current.phase == SessionPhase.gameOver) return;

    if (current.isLast) {
      state = AsyncData(current.copyWith(phase: SessionPhase.finished));
    } else {
      state = AsyncData(current.copyWith(
        currentIndex: current.currentIndex + 1,
        phase: SessionPhase.playing,
        lastOutcome: null,
      ));
    }
  }
}
