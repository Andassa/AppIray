// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CourseDtoImpl _$$CourseDtoImplFromJson(Map<String, dynamic> json) =>
    _$CourseDtoImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      targetLanguage: json['target_language'] as String? ?? 'malagasy',
      sourceLanguage: json['source_language'] as String? ?? 'français',
    );

Map<String, dynamic> _$$CourseDtoImplToJson(_$CourseDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'target_language': instance.targetLanguage,
      'source_language': instance.sourceLanguage,
    };

_$LessonDtoImpl _$$LessonDtoImplFromJson(Map<String, dynamic> json) =>
    _$LessonDtoImpl(
      id: json['id'] as String,
      unitId: json['unit_id'] as String,
      title: json['title'] as String,
      order: (json['order'] as num?)?.toInt() ?? 0,
      xpReward: (json['xp_reward'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$LessonDtoImplToJson(_$LessonDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'unit_id': instance.unitId,
      'title': instance.title,
      'order': instance.order,
      'xp_reward': instance.xpReward,
    };

_$UnitDetailDtoImpl _$$UnitDetailDtoImplFromJson(Map<String, dynamic> json) =>
    _$UnitDetailDtoImpl(
      id: json['id'] as String,
      courseId: json['course_id'] as String,
      title: json['title'] as String,
      order: (json['order'] as num?)?.toInt() ?? 0,
      lessons:
          (json['lessons'] as List<dynamic>?)
              ?.map((e) => LessonDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <LessonDto>[],
    );

Map<String, dynamic> _$$UnitDetailDtoImplToJson(_$UnitDetailDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'course_id': instance.courseId,
      'title': instance.title,
      'order': instance.order,
      'lessons': instance.lessons,
    };

_$CourseDetailDtoImpl _$$CourseDetailDtoImplFromJson(
  Map<String, dynamic> json,
) => _$CourseDetailDtoImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  targetLanguage: json['target_language'] as String? ?? 'malagasy',
  sourceLanguage: json['source_language'] as String? ?? 'français',
  units:
      (json['units'] as List<dynamic>?)
          ?.map((e) => UnitDetailDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <UnitDetailDto>[],
);

Map<String, dynamic> _$$CourseDetailDtoImplToJson(
  _$CourseDetailDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'target_language': instance.targetLanguage,
  'source_language': instance.sourceLanguage,
  'units': instance.units,
};
