import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:appiray/core/utils/result.dart';
import 'package:appiray/features/auth/presentation/controllers/auth_controller.dart';
import 'package:appiray/features/profile/data/users_repository_impl.dart';
import 'package:appiray/features/profile/domain/user_entity.dart';

part 'profile_controller.g.dart';

/// Charge et expose l'utilisateur courant.
@riverpod
class ProfileController extends _$ProfileController {
  @override
  Future<User> build() async {
    final result = await ref.read(usersRepositoryProvider).getMe();
    return switch (result) {
      Success<User>(:final value) => value,
      FailureResult<User>(:final failure) => throw Exception(failure.message),
    };
  }

  Future<void> logout() =>
      ref.read(authControllerProvider.notifier).logout();

  Future<bool> updateUsername(String username) async {
    final result =
        await ref.read(usersRepositoryProvider).updateUsername(username);
    return switch (result) {
      Success<User>(:final value) => _apply(value),
      FailureResult<User>() => false,
    };
  }

  bool _apply(User user) {
    state = AsyncData(user);
    return true;
  }
}
