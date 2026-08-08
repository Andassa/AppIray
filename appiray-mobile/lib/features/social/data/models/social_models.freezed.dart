// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'social_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserSearchResultDto _$UserSearchResultDtoFromJson(Map<String, dynamic> json) {
  return _UserSearchResultDto.fromJson(json);
}

/// @nodoc
mixin _$UserSearchResultDto {
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'xp_total')
  int get xpTotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'friendship_status')
  String get friendshipStatus => throw _privateConstructorUsedError;

  /// Serializes this UserSearchResultDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserSearchResultDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserSearchResultDtoCopyWith<UserSearchResultDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSearchResultDtoCopyWith<$Res> {
  factory $UserSearchResultDtoCopyWith(
    UserSearchResultDto value,
    $Res Function(UserSearchResultDto) then,
  ) = _$UserSearchResultDtoCopyWithImpl<$Res, UserSearchResultDto>;
  @useResult
  $Res call({
    @JsonKey(name: 'user_id') String userId,
    String username,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'xp_total') int xpTotal,
    @JsonKey(name: 'friendship_status') String friendshipStatus,
  });
}

/// @nodoc
class _$UserSearchResultDtoCopyWithImpl<$Res, $Val extends UserSearchResultDto>
    implements $UserSearchResultDtoCopyWith<$Res> {
  _$UserSearchResultDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserSearchResultDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? username = null,
    Object? avatarUrl = freezed,
    Object? xpTotal = null,
    Object? friendshipStatus = null,
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
            avatarUrl: freezed == avatarUrl
                ? _value.avatarUrl
                : avatarUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            xpTotal: null == xpTotal
                ? _value.xpTotal
                : xpTotal // ignore: cast_nullable_to_non_nullable
                      as int,
            friendshipStatus: null == friendshipStatus
                ? _value.friendshipStatus
                : friendshipStatus // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserSearchResultDtoImplCopyWith<$Res>
    implements $UserSearchResultDtoCopyWith<$Res> {
  factory _$$UserSearchResultDtoImplCopyWith(
    _$UserSearchResultDtoImpl value,
    $Res Function(_$UserSearchResultDtoImpl) then,
  ) = __$$UserSearchResultDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'user_id') String userId,
    String username,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'xp_total') int xpTotal,
    @JsonKey(name: 'friendship_status') String friendshipStatus,
  });
}

/// @nodoc
class __$$UserSearchResultDtoImplCopyWithImpl<$Res>
    extends _$UserSearchResultDtoCopyWithImpl<$Res, _$UserSearchResultDtoImpl>
    implements _$$UserSearchResultDtoImplCopyWith<$Res> {
  __$$UserSearchResultDtoImplCopyWithImpl(
    _$UserSearchResultDtoImpl _value,
    $Res Function(_$UserSearchResultDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserSearchResultDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? username = null,
    Object? avatarUrl = freezed,
    Object? xpTotal = null,
    Object? friendshipStatus = null,
  }) {
    return _then(
      _$UserSearchResultDtoImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        avatarUrl: freezed == avatarUrl
            ? _value.avatarUrl
            : avatarUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        xpTotal: null == xpTotal
            ? _value.xpTotal
            : xpTotal // ignore: cast_nullable_to_non_nullable
                  as int,
        friendshipStatus: null == friendshipStatus
            ? _value.friendshipStatus
            : friendshipStatus // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserSearchResultDtoImpl implements _UserSearchResultDto {
  const _$UserSearchResultDtoImpl({
    @JsonKey(name: 'user_id') required this.userId,
    required this.username,
    @JsonKey(name: 'avatar_url') this.avatarUrl,
    @JsonKey(name: 'xp_total') this.xpTotal = 0,
    @JsonKey(name: 'friendship_status') this.friendshipStatus = 'none',
  });

  factory _$UserSearchResultDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserSearchResultDtoImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String username;
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @override
  @JsonKey(name: 'xp_total')
  final int xpTotal;
  @override
  @JsonKey(name: 'friendship_status')
  final String friendshipStatus;

  @override
  String toString() {
    return 'UserSearchResultDto(userId: $userId, username: $username, avatarUrl: $avatarUrl, xpTotal: $xpTotal, friendshipStatus: $friendshipStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSearchResultDtoImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.xpTotal, xpTotal) || other.xpTotal == xpTotal) &&
            (identical(other.friendshipStatus, friendshipStatus) ||
                other.friendshipStatus == friendshipStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    username,
    avatarUrl,
    xpTotal,
    friendshipStatus,
  );

  /// Create a copy of UserSearchResultDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSearchResultDtoImplCopyWith<_$UserSearchResultDtoImpl> get copyWith =>
      __$$UserSearchResultDtoImplCopyWithImpl<_$UserSearchResultDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UserSearchResultDtoImplToJson(this);
  }
}

abstract class _UserSearchResultDto implements UserSearchResultDto {
  const factory _UserSearchResultDto({
    @JsonKey(name: 'user_id') required final String userId,
    required final String username,
    @JsonKey(name: 'avatar_url') final String? avatarUrl,
    @JsonKey(name: 'xp_total') final int xpTotal,
    @JsonKey(name: 'friendship_status') final String friendshipStatus,
  }) = _$UserSearchResultDtoImpl;

  factory _UserSearchResultDto.fromJson(Map<String, dynamic> json) =
      _$UserSearchResultDtoImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get username;
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;
  @override
  @JsonKey(name: 'xp_total')
  int get xpTotal;
  @override
  @JsonKey(name: 'friendship_status')
  String get friendshipStatus;

  /// Create a copy of UserSearchResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserSearchResultDtoImplCopyWith<_$UserSearchResultDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FriendshipDto _$FriendshipDtoFromJson(Map<String, dynamic> json) {
  return _FriendshipDto.fromJson(json);
}

/// @nodoc
mixin _$FriendshipDto {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'friend_id')
  String get friendId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this FriendshipDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FriendshipDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendshipDtoCopyWith<FriendshipDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendshipDtoCopyWith<$Res> {
  factory $FriendshipDtoCopyWith(
    FriendshipDto value,
    $Res Function(FriendshipDto) then,
  ) = _$FriendshipDtoCopyWithImpl<$Res, FriendshipDto>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'friend_id') String friendId,
    String status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class _$FriendshipDtoCopyWithImpl<$Res, $Val extends FriendshipDto>
    implements $FriendshipDtoCopyWith<$Res> {
  _$FriendshipDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FriendshipDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? friendId = null,
    Object? status = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            friendId: null == friendId
                ? _value.friendId
                : friendId // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FriendshipDtoImplCopyWith<$Res>
    implements $FriendshipDtoCopyWith<$Res> {
  factory _$$FriendshipDtoImplCopyWith(
    _$FriendshipDtoImpl value,
    $Res Function(_$FriendshipDtoImpl) then,
  ) = __$$FriendshipDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'friend_id') String friendId,
    String status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class __$$FriendshipDtoImplCopyWithImpl<$Res>
    extends _$FriendshipDtoCopyWithImpl<$Res, _$FriendshipDtoImpl>
    implements _$$FriendshipDtoImplCopyWith<$Res> {
  __$$FriendshipDtoImplCopyWithImpl(
    _$FriendshipDtoImpl _value,
    $Res Function(_$FriendshipDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FriendshipDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? friendId = null,
    Object? status = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$FriendshipDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        friendId: null == friendId
            ? _value.friendId
            : friendId // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FriendshipDtoImpl implements _FriendshipDto {
  const _$FriendshipDtoImpl({
    required this.id,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'friend_id') required this.friendId,
    this.status = 'pending',
    @JsonKey(name: 'created_at') this.createdAt,
  });

  factory _$FriendshipDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendshipDtoImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'friend_id')
  final String friendId;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'FriendshipDto(id: $id, userId: $userId, friendId: $friendId, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendshipDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.friendId, friendId) ||
                other.friendId == friendId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, userId, friendId, status, createdAt);

  /// Create a copy of FriendshipDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendshipDtoImplCopyWith<_$FriendshipDtoImpl> get copyWith =>
      __$$FriendshipDtoImplCopyWithImpl<_$FriendshipDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FriendshipDtoImplToJson(this);
  }
}

abstract class _FriendshipDto implements FriendshipDto {
  const factory _FriendshipDto({
    required final String id,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'friend_id') required final String friendId,
    final String status,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
  }) = _$FriendshipDtoImpl;

  factory _FriendshipDto.fromJson(Map<String, dynamic> json) =
      _$FriendshipDtoImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'friend_id')
  String get friendId;
  @override
  String get status;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of FriendshipDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendshipDtoImplCopyWith<_$FriendshipDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FriendLeaderboardEntryDto _$FriendLeaderboardEntryDtoFromJson(
  Map<String, dynamic> json,
) {
  return _FriendLeaderboardEntryDto.fromJson(json);
}

/// @nodoc
mixin _$FriendLeaderboardEntryDto {
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  @JsonKey(name: 'xp_total')
  int get xpTotal => throw _privateConstructorUsedError;
  int get rank => throw _privateConstructorUsedError;

  /// Serializes this FriendLeaderboardEntryDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FriendLeaderboardEntryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendLeaderboardEntryDtoCopyWith<FriendLeaderboardEntryDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendLeaderboardEntryDtoCopyWith<$Res> {
  factory $FriendLeaderboardEntryDtoCopyWith(
    FriendLeaderboardEntryDto value,
    $Res Function(FriendLeaderboardEntryDto) then,
  ) = _$FriendLeaderboardEntryDtoCopyWithImpl<$Res, FriendLeaderboardEntryDto>;
  @useResult
  $Res call({
    @JsonKey(name: 'user_id') String userId,
    String username,
    @JsonKey(name: 'xp_total') int xpTotal,
    int rank,
  });
}

/// @nodoc
class _$FriendLeaderboardEntryDtoCopyWithImpl<
  $Res,
  $Val extends FriendLeaderboardEntryDto
>
    implements $FriendLeaderboardEntryDtoCopyWith<$Res> {
  _$FriendLeaderboardEntryDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FriendLeaderboardEntryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? username = null,
    Object? xpTotal = null,
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
            xpTotal: null == xpTotal
                ? _value.xpTotal
                : xpTotal // ignore: cast_nullable_to_non_nullable
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
abstract class _$$FriendLeaderboardEntryDtoImplCopyWith<$Res>
    implements $FriendLeaderboardEntryDtoCopyWith<$Res> {
  factory _$$FriendLeaderboardEntryDtoImplCopyWith(
    _$FriendLeaderboardEntryDtoImpl value,
    $Res Function(_$FriendLeaderboardEntryDtoImpl) then,
  ) = __$$FriendLeaderboardEntryDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'user_id') String userId,
    String username,
    @JsonKey(name: 'xp_total') int xpTotal,
    int rank,
  });
}

/// @nodoc
class __$$FriendLeaderboardEntryDtoImplCopyWithImpl<$Res>
    extends
        _$FriendLeaderboardEntryDtoCopyWithImpl<
          $Res,
          _$FriendLeaderboardEntryDtoImpl
        >
    implements _$$FriendLeaderboardEntryDtoImplCopyWith<$Res> {
  __$$FriendLeaderboardEntryDtoImplCopyWithImpl(
    _$FriendLeaderboardEntryDtoImpl _value,
    $Res Function(_$FriendLeaderboardEntryDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FriendLeaderboardEntryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? username = null,
    Object? xpTotal = null,
    Object? rank = null,
  }) {
    return _then(
      _$FriendLeaderboardEntryDtoImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        xpTotal: null == xpTotal
            ? _value.xpTotal
            : xpTotal // ignore: cast_nullable_to_non_nullable
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
class _$FriendLeaderboardEntryDtoImpl implements _FriendLeaderboardEntryDto {
  const _$FriendLeaderboardEntryDtoImpl({
    @JsonKey(name: 'user_id') required this.userId,
    required this.username,
    @JsonKey(name: 'xp_total') this.xpTotal = 0,
    this.rank = 0,
  });

  factory _$FriendLeaderboardEntryDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendLeaderboardEntryDtoImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String username;
  @override
  @JsonKey(name: 'xp_total')
  final int xpTotal;
  @override
  @JsonKey()
  final int rank;

  @override
  String toString() {
    return 'FriendLeaderboardEntryDto(userId: $userId, username: $username, xpTotal: $xpTotal, rank: $rank)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendLeaderboardEntryDtoImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.xpTotal, xpTotal) || other.xpTotal == xpTotal) &&
            (identical(other.rank, rank) || other.rank == rank));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, username, xpTotal, rank);

  /// Create a copy of FriendLeaderboardEntryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendLeaderboardEntryDtoImplCopyWith<_$FriendLeaderboardEntryDtoImpl>
  get copyWith =>
      __$$FriendLeaderboardEntryDtoImplCopyWithImpl<
        _$FriendLeaderboardEntryDtoImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FriendLeaderboardEntryDtoImplToJson(this);
  }
}

abstract class _FriendLeaderboardEntryDto implements FriendLeaderboardEntryDto {
  const factory _FriendLeaderboardEntryDto({
    @JsonKey(name: 'user_id') required final String userId,
    required final String username,
    @JsonKey(name: 'xp_total') final int xpTotal,
    final int rank,
  }) = _$FriendLeaderboardEntryDtoImpl;

  factory _FriendLeaderboardEntryDto.fromJson(Map<String, dynamic> json) =
      _$FriendLeaderboardEntryDtoImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get username;
  @override
  @JsonKey(name: 'xp_total')
  int get xpTotal;
  @override
  int get rank;

  /// Create a copy of FriendLeaderboardEntryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendLeaderboardEntryDtoImplCopyWith<_$FriendLeaderboardEntryDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}
