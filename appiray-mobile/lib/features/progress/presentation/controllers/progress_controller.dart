import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:appiray/core/utils/result.dart';
import 'package:appiray/features/lesson_player/data/progress_repository_impl.dart';
import 'package:appiray/features/lesson_player/domain/lesson_entities.dart';
import 'package:appiray/features/profile/data/users_repository_impl.dart';
import 'package:appiray/features/profile/domain/user_entity.dart';

part 'progress_controller.g.dart';

/// Vue agrégée de la progression : stats utilisateur + état des cœurs/gemmes.
class ProgressOverview {
  const ProgressOverview({required this.user, required this.hearts});
  final User user;
  final HeartsStatus hearts;
}

@riverpod
class ProgressController extends _$ProgressController {
  @override
  Future<ProgressOverview> build() => _load();

  Future<ProgressOverview> _load() async {
    final usersRepo = ref.read(usersRepositoryProvider);
    final progressRepo = ref.read(progressRepositoryProvider);

    final userResult = await usersRepo.getMe();
    final user = switch (userResult) {
      Success<User>(:final value) => value,
      FailureResult<User>(:final failure) => throw Exception(failure.message),
    };

    final heartsResult = await progressRepo.getHearts();
    final hearts = heartsResult.valueOrNull ??
        HeartsStatus(hearts: user.hearts, maxHearts: 5, gems: user.gems);

    return ProgressOverview(user: user, hearts: hearts);
  }

  Future<void> _reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<void> refillHeartsWithGems() async {
    final result =
        await ref.read(progressRepositoryProvider).refillHeartsWithGems();
    if (result.isSuccess) await _reload();
  }

  Future<void> buyStreakFreeze() async {
    final result = await ref.read(progressRepositoryProvider).buyStreakFreeze();
    if (result.isSuccess) await _reload();
  }

  Future<void> updateDailyGoal(int goal) async {
    final result =
        await ref.read(progressRepositoryProvider).updateDailyGoal(goal);
    if (result.isSuccess) await _reload();
  }
}
