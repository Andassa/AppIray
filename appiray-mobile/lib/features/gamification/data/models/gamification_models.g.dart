// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gamification_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeagueDtoImpl _$$LeagueDtoImplFromJson(Map<String, dynamic> json) =>
    _$LeagueDtoImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      tier: (json['tier'] as num?)?.toInt() ?? 1,
      weekStart: json['week_start'] == null
          ? null
          : DateTime.parse(json['week_start'] as String),
      weekEnd: json['week_end'] == null
          ? null
          : DateTime.parse(json['week_end'] as String),
    );

Map<String, dynamic> _$$LeagueDtoImplToJson(_$LeagueDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'tier': instance.tier,
      'week_start': instance.weekStart?.toIso8601String(),
      'week_end': instance.weekEnd?.toIso8601String(),
    };

_$LeaderboardEntryDtoImpl _$$LeaderboardEntryDtoImplFromJson(
  Map<String, dynamic> json,
) => _$LeaderboardEntryDtoImpl(
  userId: json['user_id'] as String,
  username: json['username'] as String,
  xpThisWeek: (json['xp_this_week'] as num?)?.toInt() ?? 0,
  rank: (json['rank'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$LeaderboardEntryDtoImplToJson(
  _$LeaderboardEntryDtoImpl instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'username': instance.username,
  'xp_this_week': instance.xpThisWeek,
  'rank': instance.rank,
};

_$BadgeDtoImpl _$$BadgeDtoImplFromJson(Map<String, dynamic> json) =>
    _$BadgeDtoImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      iconUrl: json['icon_url'] as String?,
      criteria:
          json['criteria'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
    );

Map<String, dynamic> _$$BadgeDtoImplToJson(_$BadgeDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'icon_url': instance.iconUrl,
      'criteria': instance.criteria,
    };

_$UserBadgeDtoImpl _$$UserBadgeDtoImplFromJson(Map<String, dynamic> json) =>
    _$UserBadgeDtoImpl(
      id: json['id'] as String,
      badge: BadgeDto.fromJson(json['badge'] as Map<String, dynamic>),
      earnedAt: json['earned_at'] == null
          ? null
          : DateTime.parse(json['earned_at'] as String),
    );

Map<String, dynamic> _$$UserBadgeDtoImplToJson(_$UserBadgeDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'badge': instance.badge,
      'earned_at': instance.earnedAt?.toIso8601String(),
    };

_$DailyQuestDtoImpl _$$DailyQuestDtoImplFromJson(Map<String, dynamic> json) =>
    _$DailyQuestDtoImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      criteria:
          json['criteria'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
      xpReward: (json['xp_reward'] as num?)?.toInt() ?? 0,
      gemReward: (json['gem_reward'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$DailyQuestDtoImplToJson(_$DailyQuestDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'criteria': instance.criteria,
      'xp_reward': instance.xpReward,
      'gem_reward': instance.gemReward,
    };

_$UserDailyQuestDtoImpl _$$UserDailyQuestDtoImplFromJson(
  Map<String, dynamic> json,
) => _$UserDailyQuestDtoImpl(
  id: json['id'] as String,
  quest: DailyQuestDto.fromJson(json['quest'] as Map<String, dynamic>),
  date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
  progress: (json['progress'] as num?)?.toInt() ?? 0,
  completedAt: json['completed_at'] == null
      ? null
      : DateTime.parse(json['completed_at'] as String),
);

Map<String, dynamic> _$$UserDailyQuestDtoImplToJson(
  _$UserDailyQuestDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'quest': instance.quest,
  'date': instance.date?.toIso8601String(),
  'progress': instance.progress,
  'completed_at': instance.completedAt?.toIso8601String(),
};
