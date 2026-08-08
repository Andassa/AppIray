import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:appiray/core/utils/result.dart';
import 'package:appiray/features/lesson_player/data/progress_repository_impl.dart';
import 'package:appiray/features/lesson_player/domain/lesson_entities.dart';
import 'package:appiray/features/lesson_player/domain/progress_repository.dart';
import 'package:appiray/features/lesson_player/presentation/controllers/lesson_session_controller.dart';

class MockProgressRepository extends Mock implements ProgressRepository {}

AnswerOutcome _outcome({required bool correct, required int hearts}) =>
    AnswerOutcome(
      isCorrect: correct,
      xpGained: correct ? 10 : 0,
      gemsGained: 0,
      hearts: hearts,
      xpTotal: 100,
      gems: 0,
      currentStreak: 1,
      level: 1,
      lessonCompleted: false,
      dailyGoalReached: false,
    );

void main() {
  late MockProgressRepository progress;

  const lesson = LessonContent(
    lessonId: 'l1',
    title: 'Leçon 1',
    xpReward: 20,
    exercises: [
      Exercise(id: 'e1', lessonId: 'l1', type: ExerciseType.mcq, content: {}),
      Exercise(id: 'e2', lessonId: 'l1', type: ExerciseType.translate, content: {}),
    ],
  );

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [progressRepositoryProvider.overrideWithValue(progress)],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    progress = MockProgressRepository();
    when(() => progress.getLesson('l1'))
        .thenAnswer((_) async => const Result.success(lesson));
    when(() => progress.getHearts()).thenAnswer(
      (_) async => const Result.success(
        HeartsStatus(hearts: 5, maxHearts: 5, gems: 0),
      ),
    );
  });

  test('chargement initial : phase playing, exercices présents', () async {
    final container = makeContainer();
    final state =
        await container.read(lessonSessionControllerProvider('l1').future);

    expect(state.phase, SessionPhase.playing);
    expect(state.total, 2);
    expect(state.heartsRemaining, 5);
  });

  test('réponse correcte -> feedback + score incrémenté', () async {
    when(() => progress.submitAnswer(
          exerciseId: any(named: 'exerciseId'),
          answer: any(named: 'answer'),
          practice: any(named: 'practice'),
        )).thenAnswer((_) async =>
        Result.success(_outcome(correct: true, hearts: 5)));

    final container = makeContainer();
    final notifier =
        container.read(lessonSessionControllerProvider('l1').notifier);
    await container.read(lessonSessionControllerProvider('l1').future);

    await notifier.submitAnswer('bonne réponse');

    final state = container.read(lessonSessionControllerProvider('l1')).value!;
    expect(state.phase, SessionPhase.feedback);
    expect(state.correctCount, 1);

    notifier.next();
    final advanced =
        container.read(lessonSessionControllerProvider('l1')).value!;
    expect(advanced.currentIndex, 1);
    expect(advanced.phase, SessionPhase.playing);
  });

  test('plus de cœurs -> game over', () async {
    when(() => progress.submitAnswer(
          exerciseId: any(named: 'exerciseId'),
          answer: any(named: 'answer'),
          practice: any(named: 'practice'),
        )).thenAnswer((_) async =>
        Result.success(_outcome(correct: false, hearts: 0)));

    final container = makeContainer();
    final notifier =
        container.read(lessonSessionControllerProvider('l1').notifier);
    await container.read(lessonSessionControllerProvider('l1').future);

    await notifier.submitAnswer('mauvaise');

    final state = container.read(lessonSessionControllerProvider('l1')).value!;
    expect(state.phase, SessionPhase.gameOver);
    expect(state.heartsRemaining, 0);
  });
}
