import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:appiray/core/network/api_exception.dart';
import 'package:appiray/core/providers/core_providers.dart';
import 'package:appiray/core/utils/result.dart';
import 'package:appiray/features/social/data/models/social_models.dart';
import 'package:appiray/features/social/data/social_remote_datasource.dart';
import 'package:appiray/features/social/domain/social_entities.dart';
import 'package:appiray/features/social/domain/social_repository.dart';

part 'social_repository_impl.g.dart';

@riverpod
SocialRemoteDataSource socialRemoteDataSource(SocialRemoteDataSourceRef ref) =>
    SocialRemoteDataSource(ref.watch(dioClientProvider));

@riverpod
SocialRepository socialRepository(SocialRepositoryRef ref) =>
    SocialRepositoryImpl(ref.watch(socialRemoteDataSourceProvider));

class SocialRepositoryImpl implements SocialRepository {
  SocialRepositoryImpl(this._remote);
  final SocialRemoteDataSource _remote;

  Friendship _friendship(FriendshipDto d) => Friendship(
        id: d.id,
        userId: d.userId,
        friendId: d.friendId,
        status: FriendshipStatus.fromApi(d.status),
      );

  @override
  Future<Result<List<UserSearchResult>>> searchUsers(String query) =>
      _guard(() async {
        final list = await _remote.searchUsers(query);
        return list
            .map((d) => UserSearchResult(
                  userId: d.userId,
                  username: d.username,
                  xpTotal: d.xpTotal,
                  friendshipStatus:
                      FriendshipStatus.fromApi(d.friendshipStatus),
                  avatarUrl: d.avatarUrl,
                ))
            .toList();
      });

  @override
  Future<Result<List<Friendship>>> listFriends() => _guard(() async {
        final list = await _remote.listFriends();
        return list.map(_friendship).toList();
      });

  @override
  Future<Result<Friendship>> requestFriend(String friendId) =>
      _guard(() async => _friendship(await _remote.requestFriend(friendId)));

  @override
  Future<Result<Friendship>> acceptFriend(String friendshipId) => _guard(
      () async => _friendship(await _remote.acceptFriend(friendshipId)));

  @override
  Future<Result<List<FriendLeaderboardEntry>>> friendsLeaderboard() =>
      _guard(() async {
        final list = await _remote.friendsLeaderboard();
        return list
            .map((d) => FriendLeaderboardEntry(
                  userId: d.userId,
                  username: d.username,
                  xpTotal: d.xpTotal,
                  rank: d.rank,
                ))
            .toList();
      });

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
