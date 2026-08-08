// Entités domaine du social.

enum FriendshipStatus {
  none,
  pending,
  accepted;

  static FriendshipStatus fromApi(String raw) => switch (raw) {
        'pending' => FriendshipStatus.pending,
        'accepted' => FriendshipStatus.accepted,
        _ => FriendshipStatus.none,
      };
}

class UserSearchResult {
  const UserSearchResult({
    required this.userId,
    required this.username,
    required this.xpTotal,
    required this.friendshipStatus,
    this.avatarUrl,
  });
  final String userId;
  final String username;
  final int xpTotal;
  final FriendshipStatus friendshipStatus;
  final String? avatarUrl;
}

class Friendship {
  const Friendship({
    required this.id,
    required this.userId,
    required this.friendId,
    required this.status,
  });
  final String id;
  final String userId;
  final String friendId;
  final FriendshipStatus status;
}

class FriendLeaderboardEntry {
  const FriendLeaderboardEntry({
    required this.userId,
    required this.username,
    required this.xpTotal,
    required this.rank,
  });
  final String userId;
  final String username;
  final int xpTotal;
  final int rank;
}
