// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserDtoImpl _$$UserDtoImplFromJson(Map<String, dynamic> json) =>
    _$UserDtoImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      role: json['role'] as String? ?? 'user',
      isEmailVerified: json['is_email_verified'] as bool? ?? false,
      avatarUrl: json['avatar_url'] as String?,
      xpTotal: (json['xp_total'] as num?)?.toInt() ?? 0,
      gems: (json['gems'] as num?)?.toInt() ?? 0,
      currentStreak: (json['current_streak'] as num?)?.toInt() ?? 0,
      longestStreak: (json['longest_streak'] as num?)?.toInt() ?? 0,
      hearts: (json['hearts'] as num?)?.toInt() ?? 0,
      heartRefillAt: json['heart_refill_at'] == null
          ? null
          : DateTime.parse(json['heart_refill_at'] as String),
      dailyXpGoal: (json['daily_xp_goal'] as num?)?.toInt() ?? 50,
      level: (json['level'] as num?)?.toInt() ?? 1,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      lastActiveAt: json['last_active_at'] == null
          ? null
          : DateTime.parse(json['last_active_at'] as String),
    );

Map<String, dynamic> _$$UserDtoImplToJson(_$UserDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'role': instance.role,
      'is_email_verified': instance.isEmailVerified,
      'avatar_url': instance.avatarUrl,
      'xp_total': instance.xpTotal,
      'gems': instance.gems,
      'current_streak': instance.currentStreak,
      'longest_streak': instance.longestStreak,
      'hearts': instance.hearts,
      'heart_refill_at': instance.heartRefillAt?.toIso8601String(),
      'daily_xp_goal': instance.dailyXpGoal,
      'level': instance.level,
      'created_at': instance.createdAt?.toIso8601String(),
      'last_active_at': instance.lastActiveAt?.toIso8601String(),
    };
