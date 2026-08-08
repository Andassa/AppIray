import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:appiray/core/utils/result.dart';
import 'package:appiray/features/social/data/social_repository_impl.dart';
import 'package:appiray/features/social/domain/social_entities.dart';

part 'social_providers.g.dart';

T _unwrap<T>(Result<T> result) => switch (result) {
      Success<T>(:final value) => value,
      FailureResult<T>(:final failure) => throw Exception(failure.message),
    };

/// Recherche d'utilisateurs (état = derniers résultats).
@riverpod
class UserSearchController extends _$UserSearchController {
  @override
  Future<List<UserSearchResult>> build() async => const [];

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = const AsyncData([]);
      return;
    }
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async =>
          _unwrap(await ref.read(socialRepositoryProvider).searchUsers(query)),
    );
  }

  Future<bool> sendRequest(String userId) async {
    final result =
        await ref.read(socialRepositoryProvider).requestFriend(userId);
    return result.isSuccess;
  }
}

/// Liste d'amis, avec action d'acceptation.
@riverpod
class FriendsController extends _$FriendsController {
  @override
  Future<List<Friendship>> build() async =>
      _unwrap(await ref.read(socialRepositoryProvider).listFriends());

  Future<void> accept(String friendshipId) async {
    final result =
        await ref.read(socialRepositoryProvider).acceptFriend(friendshipId);
    if (result.isSuccess) ref.invalidateSelf();
  }
}

@riverpod
Future<List<FriendLeaderboardEntry>> friendsLeaderboard(
        FriendsLeaderboardRef ref) async =>
    _unwrap(await ref.read(socialRepositoryProvider).friendsLeaderboard());
