import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:appiray/core/utils/result.dart';
import 'package:appiray/features/lesson_player/domain/lesson_entities.dart';
import 'package:appiray/features/placement_test/data/placement_repository_impl.dart';
import 'package:appiray/features/placement_test/domain/placement_entities.dart';
import 'package:appiray/features/placement_test/domain/placement_repository.dart';
import 'package:appiray/features/placement_test/presentation/controllers/placement_test_controller.dart';

class MockPlacementRepository extends Mock implements PlacementRepository {}

void main() {
  late MockPlacementRepository repo;

  const exercises = [
    Exercise(id: 'e1', lessonId: 'l1', type: ExerciseType.mcq, content: {}),
    Exercise(
      id: 'e2',
      lessonId: 'l1',
      type: ExerciseType.translate,
      content: {},
    ),
  ];

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [placementRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    repo = MockPlacementRepository();
    when(() => repo.getExercises('c1'))
        .thenAnswer((_) async => const Result.success(exercises));
  });

  test('chargement initial : phase answering, exercices présents', () async {
    final container = makeContainer();
    final state =
        await container.read(placementTestControllerProvider('c1').future);

    expect(state.phase, PlacementPhase.answering);
    expect(state.total, 2);
    expect(state.currentIndex, 0);
    expect(state.answeredCount, 0);
  });

  test('réponse intermédiaire -> avance sans submit API', () async {
    final container = makeContainer();
    final notifier =
        container.read(placementTestControllerProvider('c1').notifier);
    await container.read(placementTestControllerProvider('c1').future);

    await notifier.submitCurrentAnswer('a1');

    final state =
        container.read(placementTestControllerProvider('c1')).value!;
    expect(state.currentIndex, 1);
    expect(state.answers['e1'], 'a1');
    expect(state.phase, PlacementPhase.answering);
    verifyNever(
      () => repo.submit(
        courseId: any(named: 'courseId'),
        answers: any(named: 'answers'),
      ),
    );
  });

  test('dernière réponse -> submit final + phase done', () async {
    when(
      () => repo.submit(
        courseId: any(named: 'courseId'),
        answers: any(named: 'answers'),
      ),
    ).thenAnswer(
      (_) async => const Result.success(
        PlacementResult(correctCount: 2, unitsUnlocked: 2),
      ),
    );

    final container = makeContainer();
    final notifier =
        container.read(placementTestControllerProvider('c1').notifier);
    await container.read(placementTestControllerProvider('c1').future);

    await notifier.submitCurrentAnswer('a1');
    await notifier.submitCurrentAnswer('a2');

    final state =
        container.read(placementTestControllerProvider('c1')).value!;
    expect(state.phase, PlacementPhase.done);
    expect(state.result?.correctCount, 2);
    expect(state.result?.unitsUnlocked, 2);
    expect(state.answers, {'e1': 'a1', 'e2': 'a2'});

    verify(
      () => repo.submit(
        courseId: 'c1',
        answers: {'e1': 'a1', 'e2': 'a2'},
      ),
    ).called(1);
  });

  test('échec submit -> reste en answering avec erreur', () async {
    when(
      () => repo.submit(
        courseId: any(named: 'courseId'),
        answers: any(named: 'answers'),
      ),
    ).thenAnswer(
      (_) async => const Result.failure(Failure('réseau')),
    );

    final container = makeContainer();
    final notifier =
        container.read(placementTestControllerProvider('c1').notifier);
    await container.read(placementTestControllerProvider('c1').future);

    await notifier.submitCurrentAnswer('a1');
    await notifier.submitCurrentAnswer('a2');

    final state =
        container.read(placementTestControllerProvider('c1')).value!;
    expect(state.phase, PlacementPhase.answering);
    expect(state.submitError, 'réseau');
    expect(state.result, isNull);
  });
}
