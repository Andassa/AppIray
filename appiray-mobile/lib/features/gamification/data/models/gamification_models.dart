import 'package:freezed_annotation/freezed_annotation.dart';

part 'gamification_models.freezed.dart';
part 'gamification_models.g.dart';

@freezed
class LeagueDto with _$LeagueDto {
  const factory LeagueDto({
    required String id,
    required String name,
    @Default(1) int tier,
    @JsonKey(name: 'week_start') DateTime? weekStart,
    @JsonKey(name: 'week_end') DateTime? weekEnd,
  }) = _LeagueDto;

  factory LeagueDto.fromJson(Map<String, dynamic> json) =>
      _$LeagueDtoFromJson(json);
}

@freezed
class LeaderboardEntryDto with _$LeaderboardEntryDto {
  const factory LeaderboardEntryDto({
    @JsonKey(name: 'user_id') required String userId,
    required String username,
    @JsonKey(name: 'xp_this_week') @Default(0) int xpThisWeek,
    @Default(0) int rank,
  }) = _LeaderboardEntryDto;

  factory LeaderboardEntryDto.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardEntryDtoFromJson(json);
}

@freezed
class BadgeDto with _$BadgeDto {
  const factory BadgeDto({
    required String id,
    required String name,
    @Default('') String description,
    @JsonKey(name: 'icon_url') String? iconUrl,
    @Default(<String, dynamic>{}) Map<String, dynamic> criteria,
  }) = _BadgeDto;

  factory BadgeDto.fromJson(Map<String, dynamic> json) =>
      _$BadgeDtoFromJson(json);
}

@freezed
class UserBadgeDto with _$UserBadgeDto {
  const factory UserBadgeDto({
    required String id,
    required BadgeDto badge,
    @JsonKey(name: 'earned_at') DateTime? earnedAt,
  }) = _UserBadgeDto;

  factory UserBadgeDto.fromJson(Map<String, dynamic> json) =>
      _$UserBadgeDtoFromJson(json);
}

@freezed
class DailyQuestDto with _$DailyQuestDto {
  const factory DailyQuestDto({
    required String id,
    required String title,
    @Default('') String description,
    @Default(<String, dynamic>{}) Map<String, dynamic> criteria,
    @JsonKey(name: 'xp_reward') @Default(0) int xpReward,
    @JsonKey(name: 'gem_reward') @Default(0) int gemReward,
  }) = _DailyQuestDto;

  factory DailyQuestDto.fromJson(Map<String, dynamic> json) =>
      _$DailyQuestDtoFromJson(json);
}

@freezed
class UserDailyQuestDto with _$UserDailyQuestDto {
  const factory UserDailyQuestDto({
    required String id,
    required DailyQuestDto quest,
    DateTime? date,
    @Default(0) int progress,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
  }) = _UserDailyQuestDto;

  factory UserDailyQuestDto.fromJson(Map<String, dynamic> json) =>
      _$UserDailyQuestDtoFromJson(json);
}
