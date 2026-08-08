import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:appiray/core/network/api_exception.dart';
import 'package:appiray/core/providers/core_providers.dart';
import 'package:appiray/core/utils/result.dart';
import 'package:appiray/features/profile/data/models/user_models.dart';
import 'package:appiray/features/profile/data/users_remote_datasource.dart';
import 'package:appiray/features/profile/domain/user_entity.dart';
import 'package:appiray/features/profile/domain/users_repository.dart';

part 'users_repository_impl.g.dart';

@riverpod
UsersRemoteDataSource usersRemoteDataSource(UsersRemoteDataSourceRef ref) =>
    UsersRemoteDataSource(ref.watch(dioClientProvider));

@riverpod
UsersRepository usersRepository(UsersRepositoryRef ref) =>
    UsersRepositoryImpl(ref.watch(usersRemoteDataSourceProvider));

class UsersRepositoryImpl implements UsersRepository {
  UsersRepositoryImpl(this._remote);
  final UsersRemoteDataSource _remote;

  User _toEntity(UserDto d) => User(
        id: d.id,
        email: d.email,
        username: d.username,
        role: d.role,
        isEmailVerified: d.isEmailVerified,
        xpTotal: d.xpTotal,
        gems: d.gems,
        currentStreak: d.currentStreak,
        longestStreak: d.longestStreak,
        hearts: d.hearts,
        dailyXpGoal: d.dailyXpGoal,
        level: d.level,
        avatarUrl: d.avatarUrl,
        heartRefillAt: d.heartRefillAt,
      );

  @override
  Future<Result<User>> getMe() =>
      _guard(() async => _toEntity(await _remote.getMe()));

  @override
  Future<Result<User>> updateUsername(String username) => _guard(
      () async => _toEntity(await _remote.updateUsername(username)));

  Future<Result<T>> _guard<T>(Future<T> Function() body) async {
    try {
      return Result.success(await body());
    } on ApiException catch (e) {
      return Result.failure(Failure.fromApiException(e));
    } catch (e) {
      return Result.failure(Failure.unexpected(e));
    }
  }
}
