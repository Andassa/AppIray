import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_models.freezed.dart';
part 'course_models.g.dart';

@freezed
class CourseDto with _$CourseDto {
  const factory CourseDto({
    required String id,
    required String title,
    String? description,
    @JsonKey(name: 'target_language') @Default('malagasy') String targetLanguage,
    @JsonKey(name: 'source_language') @Default('français') String sourceLanguage,
  }) = _CourseDto;

  factory CourseDto.fromJson(Map<String, dynamic> json) =>
      _$CourseDtoFromJson(json);
}

@freezed
class LessonDto with _$LessonDto {
  const factory LessonDto({
    required String id,
    @JsonKey(name: 'unit_id') required String unitId,
    required String title,
    @Default(0) int order,
    @JsonKey(name: 'xp_reward') @Default(0) int xpReward,
  }) = _LessonDto;

  factory LessonDto.fromJson(Map<String, dynamic> json) =>
      _$LessonDtoFromJson(json);
}

@freezed
class UnitDetailDto with _$UnitDetailDto {
  const factory UnitDetailDto({
    required String id,
    @JsonKey(name: 'course_id') required String courseId,
    required String title,
    @Default(0) int order,
    @Default(<LessonDto>[]) List<LessonDto> lessons,
  }) = _UnitDetailDto;

  factory UnitDetailDto.fromJson(Map<String, dynamic> json) =>
      _$UnitDetailDtoFromJson(json);
}

@freezed
class CourseDetailDto with _$CourseDetailDto {
  const factory CourseDetailDto({
    required String id,
    required String title,
    String? description,
    @JsonKey(name: 'target_language') @Default('malagasy') String targetLanguage,
    @JsonKey(name: 'source_language') @Default('français') String sourceLanguage,
    @Default(<UnitDetailDto>[]) List<UnitDetailDto> units,
  }) = _CourseDetailDto;

  factory CourseDetailDto.fromJson(Map<String, dynamic> json) =>
      _$CourseDetailDtoFromJson(json);
}
