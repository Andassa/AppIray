// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserSearchResultDtoImpl _$$UserSearchResultDtoImplFromJson(
  Map<String, dynamic> json,
) => _$UserSearchResultDtoImpl(
  userId: json['user_id'] as String,
  username: json['username'] as String,
  avatarUrl: json['avatar_url'] as String?,
  xpTotal: (json['xp_total'] as num?)?.toInt() ?? 0,
  friendshipStatus: json['friendship_status'] as String? ?? 'none',
);

Map<String, dynamic> _$$UserSearchResultDtoImplToJson(
  _$UserSearchResultDtoImpl instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'username': instance.username,
  'avatar_url': instance.avatarUrl,
  'xp_total': instance.xpTotal,
  'friendship_status': instance.friendshipStatus,
};

_$FriendshipDtoImpl _$$FriendshipDtoImplFromJson(Map<String, dynamic> json) =>
    _$FriendshipDtoImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      friendId: json['friend_id'] as String,
      status: json['status'] as String? ?? 'pending',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$FriendshipDtoImplToJson(_$FriendshipDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'friend_id': instance.friendId,
      'status': instance.status,
      'created_at': instance.createdAt?.toIso8601String(),
    };

_$FriendLeaderboardEntryDtoImpl _$$FriendLeaderboardEntryDtoImplFromJson(
  Map<String, dynamic> json,
) => _$FriendLeaderboardEntryDtoImpl(
  userId: json['user_id'] as String,
  username: json['username'] as String,
  xpTotal: (json['xp_total'] as num?)?.toInt() ?? 0,
  rank: (json['rank'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$FriendLeaderboardEntryDtoImplToJson(
  _$FriendLeaderboardEntryDtoImpl instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'username': instance.username,
  'xp_total': instance.xpTotal,
  'rank': instance.rank,
};
