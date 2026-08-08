import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_models.freezed.dart';
part 'user_models.g.dart';

/// Utilisateur tel que renvoyé par le backend (UserRead).
@freezed
class UserDto with _$UserDto {
  const factory UserDto({
    required String id,
    required String email,
    required String username,
    @Default('user') String role,
    @JsonKey(name: 'is_email_verified') @Default(false) bool isEmailVerified,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'xp_total') @Default(0) int xpTotal,
    @Default(0) int gems,
    @JsonKey(name: 'current_streak') @Default(0) int currentStreak,
    @JsonKey(name: 'longest_streak') @Default(0) int longestStreak,
    @Default(0) int hearts,
    @JsonKey(name: 'heart_refill_at') DateTime? heartRefillAt,
    @JsonKey(name: 'daily_xp_goal') @Default(50) int dailyXpGoal,
    @Default(1) int level,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'last_active_at') DateTime? lastActiveAt,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}
