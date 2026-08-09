// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExerciseDtoImpl _$$ExerciseDtoImplFromJson(Map<String, dynamic> json) =>
    _$ExerciseDtoImpl(
      id: json['id'] as String,
      lessonId: json['lesson_id'] as String,
      type: json['type'] as String,
      content:
          json['content'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      audioAssetId: json['audio_asset_id'] as String?,
      order: (json['order'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ExerciseDtoImplToJson(_$ExerciseDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lesson_id': instance.lessonId,
      'type': instance.type,
      'content': instance.content,
      'audio_asset_id': instance.audioAssetId,
      'order': instance.order,
    };

_$LessonDetailDtoImpl _$$LessonDetailDtoImplFromJson(
  Map<String, dynamic> json,
) => _$LessonDetailDtoImpl(
  id: json['id'] as String,
  unitId: json['unit_id'] as String,
  title: json['title'] as String,
  order: (json['order'] as num?)?.toInt() ?? 0,
  xpReward: (json['xp_reward'] as num?)?.toInt() ?? 0,
  exercises:
      (json['exercises'] as List<dynamic>?)
          ?.map((e) => ExerciseDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ExerciseDto>[],
);

Map<String, dynamic> _$$LessonDetailDtoImplToJson(
  _$LessonDetailDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'unit_id': instance.unitId,
  'title': instance.title,
  'order': instance.order,
  'xp_reward': instance.xpReward,
  'exercises': instance.exercises,
};

_$AnswerResultDtoImpl _$$AnswerResultDtoImplFromJson(
  Map<String, dynamic> json,
) => _$AnswerResultDtoImpl(
  isCorrect: json['is_correct'] as bool,
  xpGained: (json['xp_gained'] as num?)?.toInt() ?? 0,
  gemsGained: (json['gems_gained'] as num?)?.toInt() ?? 0,
  hearts: (json['hearts'] as num?)?.toInt() ?? 0,
  xpTotal: (json['xp_total'] as num?)?.toInt() ?? 0,
  gems: (json['gems'] as num?)?.toInt() ?? 0,
  currentStreak: (json['current_streak'] as num?)?.toInt() ?? 0,
  level: (json['level'] as num?)?.toInt() ?? 1,
  lessonCompleted: json['lesson_completed'] as bool? ?? false,
  dailyGoalReached: json['daily_goal_reached'] as bool? ?? false,
);

Map<String, dynamic> _$$AnswerResultDtoImplToJson(
  _$AnswerResultDtoImpl instance,
) => <String, dynamic>{
  'is_correct': instance.isCorrect,
  'xp_gained': instance.xpGained,
  'gems_gained': instance.gemsGained,
  'hearts': instance.hearts,
  'xp_total': instance.xpTotal,
  'gems': instance.gems,
  'current_streak': instance.currentStreak,
  'level': instance.level,
  'lesson_completed': instance.lessonCompleted,
  'daily_goal_reached': instance.dailyGoalReached,
};

_$ProgressDtoImpl _$$ProgressDtoImplFromJson(Map<String, dynamic> json) =>
    _$ProgressDtoImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      lessonId: json['lesson_id'] as String,
      status: json['status'] as String,
      score: (json['score'] as num?)?.toInt() ?? 0,
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
    );

Map<String, dynamic> _$$ProgressDtoImplToJson(_$ProgressDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'lesson_id': instance.lessonId,
      'status': instance.status,
      'score': instance.score,
      'completed_at': instance.completedAt?.toIso8601String(),
    };

_$HeartsStatusDtoImpl _$$HeartsStatusDtoImplFromJson(
  Map<String, dynamic> json,
) => _$HeartsStatusDtoImpl(
  hearts: (json['hearts'] as num?)?.toInt() ?? 0,
  maxHearts: (json['max_hearts'] as num?)?.toInt() ?? 5,
  heartRefillAt: json['heart_refill_at'] == null
      ? null
      : DateTime.parse(json['heart_refill_at'] as String),
  gems: (json['gems'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$HeartsStatusDtoImplToJson(
  _$HeartsStatusDtoImpl instance,
) => <String, dynamic>{
  'hearts': instance.hearts,
  'max_hearts': instance.maxHearts,
  'heart_refill_at': instance.heartRefillAt?.toIso8601String(),
  'gems': instance.gems,
};
