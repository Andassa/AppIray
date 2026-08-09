import 'package:freezed_annotation/freezed_annotation.dart';

part 'lesson_models.freezed.dart';
part 'lesson_models.g.dart';

/// Exercice tel que renvoyé par le backend (ExerciseRead / PracticeExercise).
@freezed
class ExerciseDto with _$ExerciseDto {
  const factory ExerciseDto({
    required String id,
    @JsonKey(name: 'lesson_id') required String lessonId,
    required String type,
    @Default(<String, dynamic>{}) Map<String, dynamic> content,
    @JsonKey(name: 'audio_asset_id') String? audioAssetId,
    @Default(0) int order,
  }) = _ExerciseDto;

  factory ExerciseDto.fromJson(Map<String, dynamic> json) =>
      _$ExerciseDtoFromJson(json);
}

/// Détail d'une leçon (LessonDetail).
@freezed
class LessonDetailDto with _$LessonDetailDto {
  const factory LessonDetailDto({
    required String id,
    @JsonKey(name: 'unit_id') required String unitId,
    required String title,
    @Default(0) int order,
    @JsonKey(name: 'xp_reward') @Default(0) int xpReward,
    @Default(<ExerciseDto>[]) List<ExerciseDto> exercises,
  }) = _LessonDetailDto;

  factory LessonDetailDto.fromJson(Map<String, dynamic> json) =>
      _$LessonDetailDtoFromJson(json);
}

/// Résultat de soumission (AnswerResult).
@freezed
class AnswerResultDto with _$AnswerResultDto {
  const factory AnswerResultDto({
    @JsonKey(name: 'is_correct') required bool isCorrect,
    @JsonKey(name: 'xp_gained') @Default(0) int xpGained,
    @JsonKey(name: 'gems_gained') @Default(0) int gemsGained,
    @Default(0) int hearts,
    @JsonKey(name: 'xp_total') @Default(0) int xpTotal,
    @Default(0) int gems,
    @JsonKey(name: 'current_streak') @Default(0) int currentStreak,
    @Default(1) int level,
    @JsonKey(name: 'lesson_completed') @Default(false) bool lessonCompleted,
    @JsonKey(name: 'daily_goal_reached') @Default(false) bool dailyGoalReached,
  }) = _AnswerResultDto;

  factory AnswerResultDto.fromJson(Map<String, dynamic> json) =>
      _$AnswerResultDtoFromJson(json);
}

/// Progression d'une leçon (ProgressRead).
@freezed
class ProgressDto with _$ProgressDto {
  const factory ProgressDto({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'lesson_id') required String lessonId,
    required String status,
    @Default(0) int score,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
  }) = _ProgressDto;

  factory ProgressDto.fromJson(Map<String, dynamic> json) =>
      _$ProgressDtoFromJson(json);
}

/// État des cœurs (HeartsStatus).
@freezed
class HeartsStatusDto with _$HeartsStatusDto {
  const factory HeartsStatusDto({
    @Default(0) int hearts,
    @JsonKey(name: 'max_hearts') @Default(5) int maxHearts,
    @JsonKey(name: 'heart_refill_at') DateTime? heartRefillAt,
    @Default(0) int gems,
  }) = _HeartsStatusDto;

  factory HeartsStatusDto.fromJson(Map<String, dynamic> json) =>
      _$HeartsStatusDtoFromJson(json);
}
