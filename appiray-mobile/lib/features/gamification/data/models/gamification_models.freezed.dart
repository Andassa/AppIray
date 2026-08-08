// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gamification_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LeagueDto _$LeagueDtoFromJson(Map<String, dynamic> json) {
  return _LeagueDto.fromJson(json);
}

/// @nodoc
mixin _$LeagueDto {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get tier => throw _privateConstructorUsedError;
  @JsonKey(name: 'week_start')
  DateTime? get weekStart => throw _privateConstructorUsedError;
  @JsonKey(name: 'week_end')
  DateTime? get weekEnd => throw _privateConstructorUsedError;

  /// Serializes this LeagueDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LeagueDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LeagueDtoCopyWith<LeagueDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeagueDtoCopyWith<$Res> {
  factory $LeagueDtoCopyWith(LeagueDto value, $Res Function(LeagueDto) then) =
      _$LeagueDtoCopyWithImpl<$Res, LeagueDto>;
  @useResult
  $Res call({
    String id,
    String name,
    int tier,
    @JsonKey(name: 'week_start') DateTime? weekStart,
    @JsonKey(name: 'week_end') DateTime? weekEnd,
  });
}

/// @nodoc
class _$LeagueDtoCopyWithImpl<$Res, $Val extends LeagueDto>
    implements $LeagueDtoCopyWith<$Res> {
  _$LeagueDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LeagueDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? tier = null,
    Object? weekStart = freezed,
    Object? weekEnd = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            tier: null == tier
                ? _value.tier
                : tier // ignore: cast_nullable_to_non_nullable
                      as int,
            weekStart: freezed == weekStart
                ? _value.weekStart
                : weekStart // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            weekEnd: freezed == weekEnd
                ? _value.weekEnd
                : weekEnd // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LeagueDtoImplCopyWith<$Res>
    implements $LeagueDtoCopyWith<$Res> {
  factory _$$LeagueDtoImplCopyWith(
    _$LeagueDtoImpl value,
    $Res Function(_$LeagueDtoImpl) then,
  ) = __$$LeagueDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    int tier,
    @JsonKey(name: 'week_start') DateTime? weekStart,
    @JsonKey(name: 'week_end') DateTime? weekEnd,
  });
}

/// @nodoc
class __$$LeagueDtoImplCopyWithImpl<$Res>
    extends _$LeagueDtoCopyWithImpl<$Res, _$LeagueDtoImpl>
    implements _$$LeagueDtoImplCopyWith<$Res> {
  __$$LeagueDtoImplCopyWithImpl(
    _$LeagueDtoImpl _value,
    $Res Function(_$LeagueDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LeagueDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? tier = null,
    Object? weekStart = freezed,
    Object? weekEnd = freezed,
  }) {
    return _then(
      _$LeagueDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        tier: null == tier
            ? _value.tier
            : tier // ignore: cast_nullable_to_non_nullable
                  as int,
        weekStart: freezed == weekStart
            ? _value.weekStart
            : weekStart // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        weekEnd: freezed == weekEnd
            ? _value.weekEnd
            : weekEnd // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LeagueDtoImpl implements _LeagueDto {
  const _$LeagueDtoImpl({
    required this.id,
    required this.name,
    this.tier = 1,
    @JsonKey(name: 'week_start') this.weekStart,
    @JsonKey(name: 'week_end') this.weekEnd,
  });

  factory _$LeagueDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeagueDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey()
  final int tier;
  @override
  @JsonKey(name: 'week_start')
  final DateTime? weekStart;
  @override
  @JsonKey(name: 'week_end')
  final DateTime? weekEnd;

  @override
  String toString() {
    return 'LeagueDto(id: $id, name: $name, tier: $tier, weekStart: $weekStart, weekEnd: $weekEnd)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeagueDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.weekStart, weekStart) ||
                other.weekStart == weekStart) &&
            (identical(other.weekEnd, weekEnd) || other.weekEnd == weekEnd));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, tier, weekStart, weekEnd);

  /// Create a copy of LeagueDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LeagueDtoImplCopyWith<_$LeagueDtoImpl> get copyWith =>
      __$$LeagueDtoImplCopyWithImpl<_$LeagueDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LeagueDtoImplToJson(this);
  }
}

abstract class _LeagueDto implements LeagueDto {
  const factory _LeagueDto({
    required final String id,
    required final String name,
    final int tier,
    @JsonKey(name: 'week_start') final DateTime? weekStart,
    @JsonKey(name: 'week_end') final DateTime? weekEnd,
  }) = _$LeagueDtoImpl;

  factory _LeagueDto.fromJson(Map<String, dynamic> json) =
      _$LeagueDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  int get tier;
  @override
  @JsonKey(name: 'week_start')
  DateTime? get weekStart;
  @override
  @JsonKey(name: 'week_end')
  DateTime? get weekEnd;

  /// Create a copy of LeagueDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LeagueDtoImplCopyWith<_$LeagueDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LeaderboardEntryDto _$LeaderboardEntryDtoFromJson(Map<String, dynamic> json) {
  return _LeaderboardEntryDto.fromJson(json);
}

/// @nodoc
mixin _$LeaderboardEntryDto {
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  @JsonKey(name: 'xp_this_week')
  int get xpThisWeek => throw _privateConstructorUsedError;
  int get rank => throw _privateConstructorUsedError;

  /// Serializes this LeaderboardEntryDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LeaderboardEntryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LeaderboardEntryDtoCopyWith<LeaderboardEntryDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeaderboardEntryDtoCopyWith<$Res> {
  factory $LeaderboardEntryDtoCopyWith(
    LeaderboardEntryDto value,
    $Res Function(LeaderboardEntryDto) then,
  ) = _$LeaderboardEntryDtoCopyWithImpl<$Res, LeaderboardEntryDto>;
  @useResult
  $Res call({
    @JsonKey(name: 'user_id') String userId,
    String username,
    @JsonKey(name: 'xp_this_week') int xpThisWeek,
    int rank,
  });
}

/// @nodoc
class _$LeaderboardEntryDtoCopyWithImpl<$Res, $Val extends LeaderboardEntryDto>
    implements $LeaderboardEntryDtoCopyWith<$Res> {
  _$LeaderboardEntryDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LeaderboardEntryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? username = null,
    Object? xpThisWeek = null,
    Object? rank = null,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            xpThisWeek: null == xpThisWeek
                ? _value.xpThisWeek
                : xpThisWeek // ignore: cast_nullable_to_non_nullable
                      as int,
            rank: null == rank
                ? _value.rank
                : rank // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LeaderboardEntryDtoImplCopyWith<$Res>
    implements $LeaderboardEntryDtoCopyWith<$Res> {
  factory _$$LeaderboardEntryDtoImplCopyWith(
    _$LeaderboardEntryDtoImpl value,
    $Res Function(_$LeaderboardEntryDtoImpl) then,
  ) = __$$LeaderboardEntryDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'user_id') String userId,
    String username,
    @JsonKey(name: 'xp_this_week') int xpThisWeek,
    int rank,
  });
}

/// @nodoc
class __$$LeaderboardEntryDtoImplCopyWithImpl<$Res>
    extends _$LeaderboardEntryDtoCopyWithImpl<$Res, _$LeaderboardEntryDtoImpl>
    implements _$$LeaderboardEntryDtoImplCopyWith<$Res> {
  __$$LeaderboardEntryDtoImplCopyWithImpl(
    _$LeaderboardEntryDtoImpl _value,
    $Res Function(_$LeaderboardEntryDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LeaderboardEntryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? username = null,
    Object? xpThisWeek = null,
    Object? rank = null,
  }) {
    return _then(
      _$LeaderboardEntryDtoImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        xpThisWeek: null == xpThisWeek
            ? _value.xpThisWeek
            : xpThisWeek // ignore: cast_nullable_to_non_nullable
                  as int,
        rank: null == rank
            ? _value.rank
            : rank // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LeaderboardEntryDtoImpl implements _LeaderboardEntryDto {
  const _$LeaderboardEntryDtoImpl({
    @JsonKey(name: 'user_id') required this.userId,
    required this.username,
    @JsonKey(name: 'xp_this_week') this.xpThisWeek = 0,
    this.rank = 0,
  });

  factory _$LeaderboardEntryDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeaderboardEntryDtoImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String username;
  @override
  @JsonKey(name: 'xp_this_week')
  final int xpThisWeek;
  @override
  @JsonKey()
  final int rank;

  @override
  String toString() {
    return 'LeaderboardEntryDto(userId: $userId, username: $username, xpThisWeek: $xpThisWeek, rank: $rank)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeaderboardEntryDtoImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.xpThisWeek, xpThisWeek) ||
                other.xpThisWeek == xpThisWeek) &&
            (identical(other.rank, rank) || other.rank == rank));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, userId, username, xpThisWeek, rank);

  /// Create a copy of LeaderboardEntryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LeaderboardEntryDtoImplCopyWith<_$LeaderboardEntryDtoImpl> get copyWith =>
      __$$LeaderboardEntryDtoImplCopyWithImpl<_$LeaderboardEntryDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LeaderboardEntryDtoImplToJson(this);
  }
}

abstract class _LeaderboardEntryDto implements LeaderboardEntryDto {
  const factory _LeaderboardEntryDto({
    @JsonKey(name: 'user_id') required final String userId,
    required final String username,
    @JsonKey(name: 'xp_this_week') final int xpThisWeek,
    final int rank,
  }) = _$LeaderboardEntryDtoImpl;

  factory _LeaderboardEntryDto.fromJson(Map<String, dynamic> json) =
      _$LeaderboardEntryDtoImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get username;
  @override
  @JsonKey(name: 'xp_this_week')
  int get xpThisWeek;
  @override
  int get rank;

  /// Create a copy of LeaderboardEntryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LeaderboardEntryDtoImplCopyWith<_$LeaderboardEntryDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BadgeDto _$BadgeDtoFromJson(Map<String, dynamic> json) {
  return _BadgeDto.fromJson(json);
}

/// @nodoc
mixin _$BadgeDto {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_url')
  String? get iconUrl => throw _privateConstructorUsedError;
  Map<String, dynamic> get criteria => throw _privateConstructorUsedError;

  /// Serializes this BadgeDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BadgeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BadgeDtoCopyWith<BadgeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BadgeDtoCopyWith<$Res> {
  factory $BadgeDtoCopyWith(BadgeDto value, $Res Function(BadgeDto) then) =
      _$BadgeDtoCopyWithImpl<$Res, BadgeDto>;
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    @JsonKey(name: 'icon_url') String? iconUrl,
    Map<String, dynamic> criteria,
  });
}

/// @nodoc
class _$BadgeDtoCopyWithImpl<$Res, $Val extends BadgeDto>
    implements $BadgeDtoCopyWith<$Res> {
  _$BadgeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BadgeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? iconUrl = freezed,
    Object? criteria = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            iconUrl: freezed == iconUrl
                ? _value.iconUrl
                : iconUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            criteria: null == criteria
                ? _value.criteria
                : criteria // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BadgeDtoImplCopyWith<$Res>
    implements $BadgeDtoCopyWith<$Res> {
  factory _$$BadgeDtoImplCopyWith(
    _$BadgeDtoImpl value,
    $Res Function(_$BadgeDtoImpl) then,
  ) = __$$BadgeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    @JsonKey(name: 'icon_url') String? iconUrl,
    Map<String, dynamic> criteria,
  });
}

/// @nodoc
class __$$BadgeDtoImplCopyWithImpl<$Res>
    extends _$BadgeDtoCopyWithImpl<$Res, _$BadgeDtoImpl>
    implements _$$BadgeDtoImplCopyWith<$Res> {
  __$$BadgeDtoImplCopyWithImpl(
    _$BadgeDtoImpl _value,
    $Res Function(_$BadgeDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BadgeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? iconUrl = freezed,
    Object? criteria = null,
  }) {
    return _then(
      _$BadgeDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        iconUrl: freezed == iconUrl
            ? _value.iconUrl
            : iconUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        criteria: null == criteria
            ? _value._criteria
            : criteria // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BadgeDtoImpl implements _BadgeDto {
  const _$BadgeDtoImpl({
    required this.id,
    required this.name,
    this.description = '',
    @JsonKey(name: 'icon_url') this.iconUrl,
    final Map<String, dynamic> criteria = const <String, dynamic>{},
  }) : _criteria = criteria;

  factory _$BadgeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BadgeDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey(name: 'icon_url')
  final String? iconUrl;
  final Map<String, dynamic> _criteria;
  @override
  @JsonKey()
  Map<String, dynamic> get criteria {
    if (_criteria is EqualUnmodifiableMapView) return _criteria;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_criteria);
  }

  @override
  String toString() {
    return 'BadgeDto(id: $id, name: $name, description: $description, iconUrl: $iconUrl, criteria: $criteria)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BadgeDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            const DeepCollectionEquality().equals(other._criteria, _criteria));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    iconUrl,
    const DeepCollectionEquality().hash(_criteria),
  );

  /// Create a copy of BadgeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BadgeDtoImplCopyWith<_$BadgeDtoImpl> get copyWith =>
      __$$BadgeDtoImplCopyWithImpl<_$BadgeDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BadgeDtoImplToJson(this);
  }
}

abstract class _BadgeDto implements BadgeDto {
  const factory _BadgeDto({
    required final String id,
    required final String name,
    final String description,
    @JsonKey(name: 'icon_url') final String? iconUrl,
    final Map<String, dynamic> criteria,
  }) = _$BadgeDtoImpl;

  factory _BadgeDto.fromJson(Map<String, dynamic> json) =
      _$BadgeDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  @JsonKey(name: 'icon_url')
  String? get iconUrl;
  @override
  Map<String, dynamic> get criteria;

  /// Create a copy of BadgeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BadgeDtoImplCopyWith<_$BadgeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserBadgeDto _$UserBadgeDtoFromJson(Map<String, dynamic> json) {
  return _UserBadgeDto.fromJson(json);
}

/// @nodoc
mixin _$UserBadgeDto {
  String get id => throw _privateConstructorUsedError;
  BadgeDto get badge => throw _privateConstructorUsedError;
  @JsonKey(name: 'earned_at')
  DateTime? get earnedAt => throw _privateConstructorUsedError;

  /// Serializes this UserBadgeDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserBadgeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserBadgeDtoCopyWith<UserBadgeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserBadgeDtoCopyWith<$Res> {
  factory $UserBadgeDtoCopyWith(
    UserBadgeDto value,
    $Res Function(UserBadgeDto) then,
  ) = _$UserBadgeDtoCopyWithImpl<$Res, UserBadgeDto>;
  @useResult
  $Res call({
    String id,
    BadgeDto badge,
    @JsonKey(name: 'earned_at') DateTime? earnedAt,
  });

  $BadgeDtoCopyWith<$Res> get badge;
}

/// @nodoc
class _$UserBadgeDtoCopyWithImpl<$Res, $Val extends UserBadgeDto>
    implements $UserBadgeDtoCopyWith<$Res> {
  _$UserBadgeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserBadgeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? badge = null,
    Object? earnedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            badge: null == badge
                ? _value.badge
                : badge // ignore: cast_nullable_to_non_nullable
                      as BadgeDto,
            earnedAt: freezed == earnedAt
                ? _value.earnedAt
                : earnedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of UserBadgeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BadgeDtoCopyWith<$Res> get badge {
    return $BadgeDtoCopyWith<$Res>(_value.badge, (value) {
      return _then(_value.copyWith(badge: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserBadgeDtoImplCopyWith<$Res>
    implements $UserBadgeDtoCopyWith<$Res> {
  factory _$$UserBadgeDtoImplCopyWith(
    _$UserBadgeDtoImpl value,
    $Res Function(_$UserBadgeDtoImpl) then,
  ) = __$$UserBadgeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    BadgeDto badge,
    @JsonKey(name: 'earned_at') DateTime? earnedAt,
  });

  @override
  $BadgeDtoCopyWith<$Res> get badge;
}

/// @nodoc
class __$$UserBadgeDtoImplCopyWithImpl<$Res>
    extends _$UserBadgeDtoCopyWithImpl<$Res, _$UserBadgeDtoImpl>
    implements _$$UserBadgeDtoImplCopyWith<$Res> {
  __$$UserBadgeDtoImplCopyWithImpl(
    _$UserBadgeDtoImpl _value,
    $Res Function(_$UserBadgeDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserBadgeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? badge = null,
    Object? earnedAt = freezed,
  }) {
    return _then(
      _$UserBadgeDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        badge: null == badge
            ? _value.badge
            : badge // ignore: cast_nullable_to_non_nullable
                  as BadgeDto,
        earnedAt: freezed == earnedAt
            ? _value.earnedAt
            : earnedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserBadgeDtoImpl implements _UserBadgeDto {
  const _$UserBadgeDtoImpl({
    required this.id,
    required this.badge,
    @JsonKey(name: 'earned_at') this.earnedAt,
  });

  factory _$UserBadgeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserBadgeDtoImplFromJson(json);

  @override
  final String id;
  @override
  final BadgeDto badge;
  @override
  @JsonKey(name: 'earned_at')
  final DateTime? earnedAt;

  @override
  String toString() {
    return 'UserBadgeDto(id: $id, badge: $badge, earnedAt: $earnedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserBadgeDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.badge, badge) || other.badge == badge) &&
            (identical(other.earnedAt, earnedAt) ||
                other.earnedAt == earnedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, badge, earnedAt);

  /// Create a copy of UserBadgeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserBadgeDtoImplCopyWith<_$UserBadgeDtoImpl> get copyWith =>
      __$$UserBadgeDtoImplCopyWithImpl<_$UserBadgeDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserBadgeDtoImplToJson(this);
  }
}

abstract class _UserBadgeDto implements UserBadgeDto {
  const factory _UserBadgeDto({
    required final String id,
    required final BadgeDto badge,
    @JsonKey(name: 'earned_at') final DateTime? earnedAt,
  }) = _$UserBadgeDtoImpl;

  factory _UserBadgeDto.fromJson(Map<String, dynamic> json) =
      _$UserBadgeDtoImpl.fromJson;

  @override
  String get id;
  @override
  BadgeDto get badge;
  @override
  @JsonKey(name: 'earned_at')
  DateTime? get earnedAt;

  /// Create a copy of UserBadgeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserBadgeDtoImplCopyWith<_$UserBadgeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyQuestDto _$DailyQuestDtoFromJson(Map<String, dynamic> json) {
  return _DailyQuestDto.fromJson(json);
}

/// @nodoc
mixin _$DailyQuestDto {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  Map<String, dynamic> get criteria => throw _privateConstructorUsedError;
  @JsonKey(name: 'xp_reward')
  int get xpReward => throw _privateConstructorUsedError;
  @JsonKey(name: 'gem_reward')
  int get gemReward => throw _privateConstructorUsedError;

  /// Serializes this DailyQuestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyQuestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyQuestDtoCopyWith<DailyQuestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyQuestDtoCopyWith<$Res> {
  factory $DailyQuestDtoCopyWith(
    DailyQuestDto value,
    $Res Function(DailyQuestDto) then,
  ) = _$DailyQuestDtoCopyWithImpl<$Res, DailyQuestDto>;
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    Map<String, dynamic> criteria,
    @JsonKey(name: 'xp_reward') int xpReward,
    @JsonKey(name: 'gem_reward') int gemReward,
  });
}

/// @nodoc
class _$DailyQuestDtoCopyWithImpl<$Res, $Val extends DailyQuestDto>
    implements $DailyQuestDtoCopyWith<$Res> {
  _$DailyQuestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyQuestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? criteria = null,
    Object? xpReward = null,
    Object? gemReward = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            criteria: null == criteria
                ? _value.criteria
                : criteria // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            xpReward: null == xpReward
                ? _value.xpReward
                : xpReward // ignore: cast_nullable_to_non_nullable
                      as int,
            gemReward: null == gemReward
                ? _value.gemReward
                : gemReward // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DailyQuestDtoImplCopyWith<$Res>
    implements $DailyQuestDtoCopyWith<$Res> {
  factory _$$DailyQuestDtoImplCopyWith(
    _$DailyQuestDtoImpl value,
    $Res Function(_$DailyQuestDtoImpl) then,
  ) = __$$DailyQuestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    Map<String, dynamic> criteria,
    @JsonKey(name: 'xp_reward') int xpReward,
    @JsonKey(name: 'gem_reward') int gemReward,
  });
}

/// @nodoc
class __$$DailyQuestDtoImplCopyWithImpl<$Res>
    extends _$DailyQuestDtoCopyWithImpl<$Res, _$DailyQuestDtoImpl>
    implements _$$DailyQuestDtoImplCopyWith<$Res> {
  __$$DailyQuestDtoImplCopyWithImpl(
    _$DailyQuestDtoImpl _value,
    $Res Function(_$DailyQuestDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailyQuestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? criteria = null,
    Object? xpReward = null,
    Object? gemReward = null,
  }) {
    return _then(
      _$DailyQuestDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        criteria: null == criteria
            ? _value._criteria
            : criteria // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        xpReward: null == xpReward
            ? _value.xpReward
            : xpReward // ignore: cast_nullable_to_non_nullable
                  as int,
        gemReward: null == gemReward
            ? _value.gemReward
            : gemReward // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyQuestDtoImpl implements _DailyQuestDto {
  const _$DailyQuestDtoImpl({
    required this.id,
    required this.title,
    this.description = '',
    final Map<String, dynamic> criteria = const <String, dynamic>{},
    @JsonKey(name: 'xp_reward') this.xpReward = 0,
    @JsonKey(name: 'gem_reward') this.gemReward = 0,
  }) : _criteria = criteria;

  factory _$DailyQuestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyQuestDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  @JsonKey()
  final String description;
  final Map<String, dynamic> _criteria;
  @override
  @JsonKey()
  Map<String, dynamic> get criteria {
    if (_criteria is EqualUnmodifiableMapView) return _criteria;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_criteria);
  }

  @override
  @JsonKey(name: 'xp_reward')
  final int xpReward;
  @override
  @JsonKey(name: 'gem_reward')
  final int gemReward;

  @override
  String toString() {
    return 'DailyQuestDto(id: $id, title: $title, description: $description, criteria: $criteria, xpReward: $xpReward, gemReward: $gemReward)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyQuestDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._criteria, _criteria) &&
            (identical(other.xpReward, xpReward) ||
                other.xpReward == xpReward) &&
            (identical(other.gemReward, gemReward) ||
                other.gemReward == gemReward));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    const DeepCollectionEquality().hash(_criteria),
    xpReward,
    gemReward,
  );

  /// Create a copy of DailyQuestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyQuestDtoImplCopyWith<_$DailyQuestDtoImpl> get copyWith =>
      __$$DailyQuestDtoImplCopyWithImpl<_$DailyQuestDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyQuestDtoImplToJson(this);
  }
}

abstract class _DailyQuestDto implements DailyQuestDto {
  const factory _DailyQuestDto({
    required final String id,
    required final String title,
    final String description,
    final Map<String, dynamic> criteria,
    @JsonKey(name: 'xp_reward') final int xpReward,
    @JsonKey(name: 'gem_reward') final int gemReward,
  }) = _$DailyQuestDtoImpl;

  factory _DailyQuestDto.fromJson(Map<String, dynamic> json) =
      _$DailyQuestDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  Map<String, dynamic> get criteria;
  @override
  @JsonKey(name: 'xp_reward')
  int get xpReward;
  @override
  @JsonKey(name: 'gem_reward')
  int get gemReward;

  /// Create a copy of DailyQuestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyQuestDtoImplCopyWith<_$DailyQuestDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserDailyQuestDto _$UserDailyQuestDtoFromJson(Map<String, dynamic> json) {
  return _UserDailyQuestDto.fromJson(json);
}

/// @nodoc
mixin _$UserDailyQuestDto {
  String get id => throw _privateConstructorUsedError;
  DailyQuestDto get quest => throw _privateConstructorUsedError;
  DateTime? get date => throw _privateConstructorUsedError;
  int get progress => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// Serializes this UserDailyQuestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserDailyQuestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserDailyQuestDtoCopyWith<UserDailyQuestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserDailyQuestDtoCopyWith<$Res> {
  factory $UserDailyQuestDtoCopyWith(
    UserDailyQuestDto value,
    $Res Function(UserDailyQuestDto) then,
  ) = _$UserDailyQuestDtoCopyWithImpl<$Res, UserDailyQuestDto>;
  @useResult
  $Res call({
    String id,
    DailyQuestDto quest,
    DateTime? date,
    int progress,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
  });

  $DailyQuestDtoCopyWith<$Res> get quest;
}

/// @nodoc
class _$UserDailyQuestDtoCopyWithImpl<$Res, $Val extends UserDailyQuestDto>
    implements $UserDailyQuestDtoCopyWith<$Res> {
  _$UserDailyQuestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserDailyQuestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quest = null,
    Object? date = freezed,
    Object? progress = null,
    Object? completedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            quest: null == quest
                ? _value.quest
                : quest // ignore: cast_nullable_to_non_nullable
                      as DailyQuestDto,
            date: freezed == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            progress: null == progress
                ? _value.progress
                : progress // ignore: cast_nullable_to_non_nullable
                      as int,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of UserDailyQuestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DailyQuestDtoCopyWith<$Res> get quest {
    return $DailyQuestDtoCopyWith<$Res>(_value.quest, (value) {
      return _then(_value.copyWith(quest: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserDailyQuestDtoImplCopyWith<$Res>
    implements $UserDailyQuestDtoCopyWith<$Res> {
  factory _$$UserDailyQuestDtoImplCopyWith(
    _$UserDailyQuestDtoImpl value,
    $Res Function(_$UserDailyQuestDtoImpl) then,
  ) = __$$UserDailyQuestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    DailyQuestDto quest,
    DateTime? date,
    int progress,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
  });

  @override
  $DailyQuestDtoCopyWith<$Res> get quest;
}

/// @nodoc
class __$$UserDailyQuestDtoImplCopyWithImpl<$Res>
    extends _$UserDailyQuestDtoCopyWithImpl<$Res, _$UserDailyQuestDtoImpl>
    implements _$$UserDailyQuestDtoImplCopyWith<$Res> {
  __$$UserDailyQuestDtoImplCopyWithImpl(
    _$UserDailyQuestDtoImpl _value,
    $Res Function(_$UserDailyQuestDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserDailyQuestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quest = null,
    Object? date = freezed,
    Object? progress = null,
    Object? completedAt = freezed,
  }) {
    return _then(
      _$UserDailyQuestDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        quest: null == quest
            ? _value.quest
            : quest // ignore: cast_nullable_to_non_nullable
                  as DailyQuestDto,
        date: freezed == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        progress: null == progress
            ? _value.progress
            : progress // ignore: cast_nullable_to_non_nullable
                  as int,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserDailyQuestDtoImpl implements _UserDailyQuestDto {
  const _$UserDailyQuestDtoImpl({
    required this.id,
    required this.quest,
    this.date,
    this.progress = 0,
    @JsonKey(name: 'completed_at') this.completedAt,
  });

  factory _$UserDailyQuestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserDailyQuestDtoImplFromJson(json);

  @override
  final String id;
  @override
  final DailyQuestDto quest;
  @override
  final DateTime? date;
  @override
  @JsonKey()
  final int progress;
  @override
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;

  @override
  String toString() {
    return 'UserDailyQuestDto(id: $id, quest: $quest, date: $date, progress: $progress, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserDailyQuestDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quest, quest) || other.quest == quest) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, quest, date, progress, completedAt);

  /// Create a copy of UserDailyQuestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserDailyQuestDtoImplCopyWith<_$UserDailyQuestDtoImpl> get copyWith =>
      __$$UserDailyQuestDtoImplCopyWithImpl<_$UserDailyQuestDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UserDailyQuestDtoImplToJson(this);
  }
}

abstract class _UserDailyQuestDto implements UserDailyQuestDto {
  const factory _UserDailyQuestDto({
    required final String id,
    required final DailyQuestDto quest,
    final DateTime? date,
    final int progress,
    @JsonKey(name: 'completed_at') final DateTime? completedAt,
  }) = _$UserDailyQuestDtoImpl;

  factory _UserDailyQuestDto.fromJson(Map<String, dynamic> json) =
      _$UserDailyQuestDtoImpl.fromJson;

  @override
  String get id;
  @override
  DailyQuestDto get quest;
  @override
  DateTime? get date;
  @override
  int get progress;
  @override
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt;

  /// Create a copy of UserDailyQuestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserDailyQuestDtoImplCopyWith<_$UserDailyQuestDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
