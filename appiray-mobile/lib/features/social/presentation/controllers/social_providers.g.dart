// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$friendsLeaderboardHash() =>
    r'cd5c17da54c89b9f4cb936c305eff0347b80a569';

/// See also [friendsLeaderboard].
@ProviderFor(friendsLeaderboard)
final friendsLeaderboardProvider =
    AutoDisposeFutureProvider<List<FriendLeaderboardEntry>>.internal(
      friendsLeaderboard,
      name: r'friendsLeaderboardProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$friendsLeaderboardHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FriendsLeaderboardRef =
    AutoDisposeFutureProviderRef<List<FriendLeaderboardEntry>>;
String _$userSearchControllerHash() =>
    r'4df4402462947b565b678c820a0905f6eb377812';

/// Recherche d'utilisateurs (état = derniers résultats).
///
/// Copied from [UserSearchController].
@ProviderFor(UserSearchController)
final userSearchControllerProvider =
    AutoDisposeAsyncNotifierProvider<
      UserSearchController,
      List<UserSearchResult>
    >.internal(
      UserSearchController.new,
      name: r'userSearchControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userSearchControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UserSearchController =
    AutoDisposeAsyncNotifier<List<UserSearchResult>>;
String _$friendsControllerHash() => r'043c0073faf3606c7f27c1ba241ab40fb8ad2b52';

/// Liste d'amis, avec action d'acceptation.
///
/// Copied from [FriendsController].
@ProviderFor(FriendsController)
final friendsControllerProvider =
    AutoDisposeAsyncNotifierProvider<
      FriendsController,
      List<Friendship>
    >.internal(
      FriendsController.new,
      name: r'friendsControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$friendsControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FriendsController = AutoDisposeAsyncNotifier<List<Friendship>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
