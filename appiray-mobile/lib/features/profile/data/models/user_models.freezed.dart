// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserDto _$UserDtoFromJson(Map<String, dynamic> json) {
  return _UserDto.fromJson(json);
}

/// @nodoc
mixin _$UserDto {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_email_verified')
  bool get isEmailVerified => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'xp_total')
  int get xpTotal => throw _privateConstructorUsedError;
  int get gems => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_streak')
  int get currentStreak => throw _privateConstructorUsedError;
  @JsonKey(name: 'longest_streak')
  int get longestStreak => throw _privateConstructorUsedError;
  int get hearts => throw _privateConstructorUsedError;
  @JsonKey(name: 'heart_refill_at')
  DateTime? get heartRefillAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'daily_xp_goal')
  int get dailyXpGoal => throw _privateConstructorUsedError;
  int get level => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_active_at')
  DateTime? get lastActiveAt => throw _privateConstructorUsedError;

  /// Serializes this UserDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserDtoCopyWith<UserDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserDtoCopyWith<$Res> {
  factory $UserDtoCopyWith(UserDto value, $Res Function(UserDto) then) =
      _$UserDtoCopyWithImpl<$Res, UserDto>;
  @useResult
  $Res call({
    String id,
    String email,
    String username,
    String role,
    @JsonKey(name: 'is_email_verified') bool isEmailVerified,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'xp_total') int xpTotal,
    int gems,
    @JsonKey(name: 'current_streak') int currentStreak,
    @JsonKey(name: 'longest_streak') int longestStreak,
    int hearts,
    @JsonKey(name: 'heart_refill_at') DateTime? heartRefillAt,
    @JsonKey(name: 'daily_xp_goal') int dailyXpGoal,
    int level,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'last_active_at') DateTime? lastActiveAt,
  });
}

/// @nodoc
class _$UserDtoCopyWithImpl<$Res, $Val extends UserDto>
    implements $UserDtoCopyWith<$Res> {
  _$UserDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? username = null,
    Object? role = null,
    Object? isEmailVerified = null,
    Object? avatarUrl = freezed,
    Object? xpTotal = null,
    Object? gems = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? hearts = null,
    Object? heartRefillAt = freezed,
    Object? dailyXpGoal = null,
    Object? level = null,
    Object? createdAt = freezed,
    Object? lastActiveAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
            isEmailVerified: null == isEmailVerified
                ? _value.isEmailVerified
                : isEmailVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
            avatarUrl: freezed == avatarUrl
                ? _value.avatarUrl
                : avatarUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            xpTotal: null == xpTotal
                ? _value.xpTotal
                : xpTotal // ignore: cast_nullable_to_non_nullable
                      as int,
            gems: null == gems
                ? _value.gems
                : gems // ignore: cast_nullable_to_non_nullable
                      as int,
            currentStreak: null == currentStreak
                ? _value.currentStreak
                : currentStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            longestStreak: null == longestStreak
                ? _value.longestStreak
                : longestStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            hearts: null == hearts
                ? _value.hearts
                : hearts // ignore: cast_nullable_to_non_nullable
                      as int,
            heartRefillAt: freezed == heartRefillAt
                ? _value.heartRefillAt
                : heartRefillAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            dailyXpGoal: null == dailyXpGoal
                ? _value.dailyXpGoal
                : dailyXpGoal // ignore: cast_nullable_to_non_nullable
                      as int,
            level: null == level
                ? _value.level
                : level // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            lastActiveAt: freezed == lastActiveAt
                ? _value.lastActiveAt
                : lastActiveAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserDtoImplCopyWith<$Res> implements $UserDtoCopyWith<$Res> {
  factory _$$UserDtoImplCopyWith(
    _$UserDtoImpl value,
    $Res Function(_$UserDtoImpl) then,
  ) = __$$UserDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String email,
    String username,
    String role,
    @JsonKey(name: 'is_email_verified') bool isEmailVerified,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'xp_total') int xpTotal,
    int gems,
    @JsonKey(name: 'current_streak') int currentStreak,
    @JsonKey(name: 'longest_streak') int longestStreak,
    int hearts,
    @JsonKey(name: 'heart_refill_at') DateTime? heartRefillAt,
    @JsonKey(name: 'daily_xp_goal') int dailyXpGoal,
    int level,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'last_active_at') DateTime? lastActiveAt,
  });
}

/// @nodoc
class __$$UserDtoImplCopyWithImpl<$Res>
    extends _$UserDtoCopyWithImpl<$Res, _$UserDtoImpl>
    implements _$$UserDtoImplCopyWith<$Res> {
  __$$UserDtoImplCopyWithImpl(
    _$UserDtoImpl _value,
    $Res Function(_$UserDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? username = null,
    Object? role = null,
    Object? isEmailVerified = null,
    Object? avatarUrl = freezed,
    Object? xpTotal = null,
    Object? gems = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? hearts = null,
    Object? heartRefillAt = freezed,
    Object? dailyXpGoal = null,
    Object? level = null,
    Object? createdAt = freezed,
    Object? lastActiveAt = freezed,
  }) {
    return _then(
      _$UserDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        isEmailVerified: null == isEmailVerified
            ? _value.isEmailVerified
            : isEmailVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        avatarUrl: freezed == avatarUrl
            ? _value.avatarUrl
            : avatarUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        xpTotal: null == xpTotal
            ? _value.xpTotal
            : xpTotal // ignore: cast_nullable_to_non_nullable
                  as int,
        gems: null == gems
            ? _value.gems
            : gems // ignore: cast_nullable_to_non_nullable
                  as int,
        currentStreak: null == currentStreak
            ? _value.currentStreak
            : currentStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        longestStreak: null == longestStreak
            ? _value.longestStreak
            : longestStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        hearts: null == hearts
            ? _value.hearts
            : hearts // ignore: cast_nullable_to_non_nullable
                  as int,
        heartRefillAt: freezed == heartRefillAt
            ? _value.heartRefillAt
            : heartRefillAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        dailyXpGoal: null == dailyXpGoal
            ? _value.dailyXpGoal
            : dailyXpGoal // ignore: cast_nullable_to_non_nullable
                  as int,
        level: null == level
            ? _value.level
            : level // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        lastActiveAt: freezed == lastActiveAt
            ? _value.lastActiveAt
            : lastActiveAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserDtoImpl implements _UserDto {
  const _$UserDtoImpl({
    required this.id,
    required this.email,
    required this.username,
    this.role = 'user',
    @JsonKey(name: 'is_email_verified') this.isEmailVerified = false,
    @JsonKey(name: 'avatar_url') this.avatarUrl,
    @JsonKey(name: 'xp_total') this.xpTotal = 0,
    this.gems = 0,
    @JsonKey(name: 'current_streak') this.currentStreak = 0,
    @JsonKey(name: 'longest_streak') this.longestStreak = 0,
    this.hearts = 0,
    @JsonKey(name: 'heart_refill_at') this.heartRefillAt,
    @JsonKey(name: 'daily_xp_goal') this.dailyXpGoal = 50,
    this.level = 1,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'last_active_at') this.lastActiveAt,
  });

  factory _$UserDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String username;
  @override
  @JsonKey()
  final String role;
  @override
  @JsonKey(name: 'is_email_verified')
  final bool isEmailVerified;
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @override
  @JsonKey(name: 'xp_total')
  final int xpTotal;
  @override
  @JsonKey()
  final int gems;
  @override
  @JsonKey(name: 'current_streak')
  final int currentStreak;
  @override
  @JsonKey(name: 'longest_streak')
  final int longestStreak;
  @override
  @JsonKey()
  final int hearts;
  @override
  @JsonKey(name: 'heart_refill_at')
  final DateTime? heartRefillAt;
  @override
  @JsonKey(name: 'daily_xp_goal')
  final int dailyXpGoal;
  @override
  @JsonKey()
  final int level;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'last_active_at')
  final DateTime? lastActiveAt;

  @override
  String toString() {
    return 'UserDto(id: $id, email: $email, username: $username, role: $role, isEmailVerified: $isEmailVerified, avatarUrl: $avatarUrl, xpTotal: $xpTotal, gems: $gems, currentStreak: $currentStreak, longestStreak: $longestStreak, hearts: $hearts, heartRefillAt: $heartRefillAt, dailyXpGoal: $dailyXpGoal, level: $level, createdAt: $createdAt, lastActiveAt: $lastActiveAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.isEmailVerified, isEmailVerified) ||
                other.isEmailVerified == isEmailVerified) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.xpTotal, xpTotal) || other.xpTotal == xpTotal) &&
            (identical(other.gems, gems) || other.gems == gems) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.hearts, hearts) || other.hearts == hearts) &&
            (identical(other.heartRefillAt, heartRefillAt) ||
                other.heartRefillAt == heartRefillAt) &&
            (identical(other.dailyXpGoal, dailyXpGoal) ||
                other.dailyXpGoal == dailyXpGoal) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastActiveAt, lastActiveAt) ||
                other.lastActiveAt == lastActiveAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    email,
    username,
    role,
    isEmailVerified,
    avatarUrl,
    xpTotal,
    gems,
    currentStreak,
    longestStreak,
    hearts,
    heartRefillAt,
    dailyXpGoal,
    level,
    createdAt,
    lastActiveAt,
  );

  /// Create a copy of UserDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserDtoImplCopyWith<_$UserDtoImpl> get copyWith =>
      __$$UserDtoImplCopyWithImpl<_$UserDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserDtoImplToJson(this);
  }
}

abstract class _UserDto implements UserDto {
  const factory _UserDto({
    required final String id,
    required final String email,
    required final String username,
    final String role,
    @JsonKey(name: 'is_email_verified') final bool isEmailVerified,
    @JsonKey(name: 'avatar_url') final String? avatarUrl,
    @JsonKey(name: 'xp_total') final int xpTotal,
    final int gems,
    @JsonKey(name: 'current_streak') final int currentStreak,
    @JsonKey(name: 'longest_streak') final int longestStreak,
    final int hearts,
    @JsonKey(name: 'heart_refill_at') final DateTime? heartRefillAt,
    @JsonKey(name: 'daily_xp_goal') final int dailyXpGoal,
    final int level,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'last_active_at') final DateTime? lastActiveAt,
  }) = _$UserDtoImpl;

  factory _UserDto.fromJson(Map<String, dynamic> json) = _$UserDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String get username;
  @override
  String get role;
  @override
  @JsonKey(name: 'is_email_verified')
  bool get isEmailVerified;
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;
  @override
  @JsonKey(name: 'xp_total')
  int get xpTotal;
  @override
  int get gems;
  @override
  @JsonKey(name: 'current_streak')
  int get currentStreak;
  @override
  @JsonKey(name: 'longest_streak')
  int get longestStreak;
  @override
  int get hearts;
  @override
  @JsonKey(name: 'heart_refill_at')
  DateTime? get heartRefillAt;
  @override
  @JsonKey(name: 'daily_xp_goal')
  int get dailyXpGoal;
  @override
  int get level;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'last_active_at')
  DateTime? get lastActiveAt;

  /// Create a copy of UserDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserDtoImplCopyWith<_$UserDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
