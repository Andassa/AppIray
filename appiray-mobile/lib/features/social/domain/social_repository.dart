import 'package:appiray/core/utils/result.dart';
import 'package:appiray/features/social/domain/social_entities.dart';

/// Contrat du repository social (domaine).
abstract interface class SocialRepository {
  Future<Result<List<UserSearchResult>>> searchUsers(String query);
  Future<Result<List<Friendship>>> listFriends();
  Future<Result<Friendship>> requestFriend(String friendId);
  Future<Result<Friendship>> acceptFriend(String friendshipId);
  Future<Result<List<FriendLeaderboardEntry>>> friendsLeaderboard();
}
