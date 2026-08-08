import 'package:freezed_annotation/freezed_annotation.dart';

part 'social_models.freezed.dart';
part 'social_models.g.dart';

@freezed
class UserSearchResultDto with _$UserSearchResultDto {
  const factory UserSearchResultDto({
    @JsonKey(name: 'user_id') required String userId,
    required String username,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'xp_total') @Default(0) int xpTotal,
    @JsonKey(name: 'friendship_status') @Default('none') String friendshipStatus,
  }) = _UserSearchResultDto;

  factory UserSearchResultDto.fromJson(Map<String, dynamic> json) =>
      _$UserSearchResultDtoFromJson(json);
}

@freezed
class FriendshipDto with _$FriendshipDto {
  const factory FriendshipDto({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'friend_id') required String friendId,
    @Default('pending') String status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _FriendshipDto;

  factory FriendshipDto.fromJson(Map<String, dynamic> json) =>
      _$FriendshipDtoFromJson(json);
}

@freezed
class FriendLeaderboardEntryDto with _$FriendLeaderboardEntryDto {
  const factory FriendLeaderboardEntryDto({
    @JsonKey(name: 'user_id') required String userId,
    required String username,
    @JsonKey(name: 'xp_total') @Default(0) int xpTotal,
    @Default(0) int rank,
  }) = _FriendLeaderboardEntryDto;

  factory FriendLeaderboardEntryDto.fromJson(Map<String, dynamic> json) =>
      _$FriendLeaderboardEntryDtoFromJson(json);
}
