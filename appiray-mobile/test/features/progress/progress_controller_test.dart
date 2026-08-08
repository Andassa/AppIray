import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:appiray/core/utils/result.dart';
import 'package:appiray/features/lesson_player/data/progress_repository_impl.dart';
import 'package:appiray/features/lesson_player/domain/lesson_entities.dart';
import 'package:appiray/features/lesson_player/domain/progress_repository.dart';
import 'package:appiray/features/profile/data/users_repository_impl.dart';
import 'package:appiray/features/profile/domain/user_entity.dart';
import 'package:appiray/features/profile/domain/users_repository.dart';
import 'package:appiray/features/progress/presentation/controllers/progress_controller.dart';

class MockUsersRepository extends Mock implements UsersRepository {}

class MockProgressRepository extends Mock implements ProgressRepository {}

void main() {
  late MockUsersRepository users;
  late MockProgressRepository progress;

  const user = User(
    id: 'u1',
    email: 'a@b.c',
    username: 'andry',
    role: 'user',
    isEmailVerified: true,
    xpTotal: 1200,
    gems: 30,
    currentStreak: 4,
    longestStreak: 10,
    hearts: 4,
    dailyXpGoal: 50,
    level: 3,
  );

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [
        usersRepositoryProvider.overrideWithValue(users),
        progressRepositoryProvider.overrideWithValue(progress),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    users = MockUsersRepository();
    progress = MockProgressRepository();
    when(() => users.getMe())
        .thenAnswer((_) async => const Result.success(user));
    when(() => progress.getHearts()).thenAnswer(
      (_) async => const Result.success(
        HeartsStatus(hearts: 4, maxHearts: 5, gems: 30),
      ),
    );
  });

  test('agrège stats utilisateur et cœurs', () async {
    final container = makeContainer();
    final overview = await container.read(progressControllerProvider.future);

    expect(overview.user.xpTotal, 1200);
    expect(overview.user.currentStreak, 4);
    expect(overview.hearts.hearts, 4);
    expect(overview.hearts.gems, 30);
  });

  test('refill cœurs recharge et relit les données', () async {
    when(() => progress.refillHeartsWithGems()).thenAnswer(
      (_) async => const Result.success(
        HeartsStatus(hearts: 5, maxHearts: 5, gems: 20),
      ),
    );

    final container = makeContainer();
    await container.read(progressControllerProvider.future);

    await container
        .read(progressControllerProvider.notifier)
        .refillHeartsWithGems();

    verify(() => progress.refillHeartsWithGems()).called(1);
    // Le controller relit /users/me + /hearts après un refill réussi.
    verify(() => users.getMe()).called(greaterThanOrEqualTo(2));
  });
}
