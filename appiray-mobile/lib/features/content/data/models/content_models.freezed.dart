// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PublicationDto _$PublicationDtoFromJson(Map<String, dynamic> json) {
  return _PublicationDto.fromJson(json);
}

/// @nodoc
mixin _$PublicationDto {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'cover_image_url')
  String? get coverImageUrl => throw _privateConstructorUsedError;
  String get author => throw _privateConstructorUsedError;
  @JsonKey(name: 'published_at')
  DateTime? get publishedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'likes_count')
  int get likesCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'comments_count')
  int get commentsCount => throw _privateConstructorUsedError;

  /// Serializes this PublicationDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PublicationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PublicationDtoCopyWith<PublicationDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PublicationDtoCopyWith<$Res> {
  factory $PublicationDtoCopyWith(
    PublicationDto value,
    $Res Function(PublicationDto) then,
  ) = _$PublicationDtoCopyWithImpl<$Res, PublicationDto>;
  @useResult
  $Res call({
    String id,
    String title,
    String body,
    String category,
    String status,
    @JsonKey(name: 'cover_image_url') String? coverImageUrl,
    String author,
    @JsonKey(name: 'published_at') DateTime? publishedAt,
    @JsonKey(name: 'likes_count') int likesCount,
    @JsonKey(name: 'comments_count') int commentsCount,
  });
}

/// @nodoc
class _$PublicationDtoCopyWithImpl<$Res, $Val extends PublicationDto>
    implements $PublicationDtoCopyWith<$Res> {
  _$PublicationDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PublicationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? category = null,
    Object? status = null,
    Object? coverImageUrl = freezed,
    Object? author = null,
    Object? publishedAt = freezed,
    Object? likesCount = null,
    Object? commentsCount = null,
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
            body: null == body
                ? _value.body
                : body // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            coverImageUrl: freezed == coverImageUrl
                ? _value.coverImageUrl
                : coverImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            author: null == author
                ? _value.author
                : author // ignore: cast_nullable_to_non_nullable
                      as String,
            publishedAt: freezed == publishedAt
                ? _value.publishedAt
                : publishedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            likesCount: null == likesCount
                ? _value.likesCount
                : likesCount // ignore: cast_nullable_to_non_nullable
                      as int,
            commentsCount: null == commentsCount
                ? _value.commentsCount
                : commentsCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PublicationDtoImplCopyWith<$Res>
    implements $PublicationDtoCopyWith<$Res> {
  factory _$$PublicationDtoImplCopyWith(
    _$PublicationDtoImpl value,
    $Res Function(_$PublicationDtoImpl) then,
  ) = __$$PublicationDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String body,
    String category,
    String status,
    @JsonKey(name: 'cover_image_url') String? coverImageUrl,
    String author,
    @JsonKey(name: 'published_at') DateTime? publishedAt,
    @JsonKey(name: 'likes_count') int likesCount,
    @JsonKey(name: 'comments_count') int commentsCount,
  });
}

/// @nodoc
class __$$PublicationDtoImplCopyWithImpl<$Res>
    extends _$PublicationDtoCopyWithImpl<$Res, _$PublicationDtoImpl>
    implements _$$PublicationDtoImplCopyWith<$Res> {
  __$$PublicationDtoImplCopyWithImpl(
    _$PublicationDtoImpl _value,
    $Res Function(_$PublicationDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PublicationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? category = null,
    Object? status = null,
    Object? coverImageUrl = freezed,
    Object? author = null,
    Object? publishedAt = freezed,
    Object? likesCount = null,
    Object? commentsCount = null,
  }) {
    return _then(
      _$PublicationDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        body: null == body
            ? _value.body
            : body // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        coverImageUrl: freezed == coverImageUrl
            ? _value.coverImageUrl
            : coverImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        author: null == author
            ? _value.author
            : author // ignore: cast_nullable_to_non_nullable
                  as String,
        publishedAt: freezed == publishedAt
            ? _value.publishedAt
            : publishedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        likesCount: null == likesCount
            ? _value.likesCount
            : likesCount // ignore: cast_nullable_to_non_nullable
                  as int,
        commentsCount: null == commentsCount
            ? _value.commentsCount
            : commentsCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PublicationDtoImpl implements _PublicationDto {
  const _$PublicationDtoImpl({
    required this.id,
    required this.title,
    this.body = '',
    this.category = 'culture',
    this.status = 'published',
    @JsonKey(name: 'cover_image_url') this.coverImageUrl,
    this.author = '',
    @JsonKey(name: 'published_at') this.publishedAt,
    @JsonKey(name: 'likes_count') this.likesCount = 0,
    @JsonKey(name: 'comments_count') this.commentsCount = 0,
  });

  factory _$PublicationDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PublicationDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  @JsonKey()
  final String body;
  @override
  @JsonKey()
  final String category;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'cover_image_url')
  final String? coverImageUrl;
  @override
  @JsonKey()
  final String author;
  @override
  @JsonKey(name: 'published_at')
  final DateTime? publishedAt;
  @override
  @JsonKey(name: 'likes_count')
  final int likesCount;
  @override
  @JsonKey(name: 'comments_count')
  final int commentsCount;

  @override
  String toString() {
    return 'PublicationDto(id: $id, title: $title, body: $body, category: $category, status: $status, coverImageUrl: $coverImageUrl, author: $author, publishedAt: $publishedAt, likesCount: $likesCount, commentsCount: $commentsCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PublicationDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.coverImageUrl, coverImageUrl) ||
                other.coverImageUrl == coverImageUrl) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt) &&
            (identical(other.likesCount, likesCount) ||
                other.likesCount == likesCount) &&
            (identical(other.commentsCount, commentsCount) ||
                other.commentsCount == commentsCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    body,
    category,
    status,
    coverImageUrl,
    author,
    publishedAt,
    likesCount,
    commentsCount,
  );

  /// Create a copy of PublicationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PublicationDtoImplCopyWith<_$PublicationDtoImpl> get copyWith =>
      __$$PublicationDtoImplCopyWithImpl<_$PublicationDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PublicationDtoImplToJson(this);
  }
}

abstract class _PublicationDto implements PublicationDto {
  const factory _PublicationDto({
    required final String id,
    required final String title,
    final String body,
    final String category,
    final String status,
    @JsonKey(name: 'cover_image_url') final String? coverImageUrl,
    final String author,
    @JsonKey(name: 'published_at') final DateTime? publishedAt,
    @JsonKey(name: 'likes_count') final int likesCount,
    @JsonKey(name: 'comments_count') final int commentsCount,
  }) = _$PublicationDtoImpl;

  factory _PublicationDto.fromJson(Map<String, dynamic> json) =
      _$PublicationDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get body;
  @override
  String get category;
  @override
  String get status;
  @override
  @JsonKey(name: 'cover_image_url')
  String? get coverImageUrl;
  @override
  String get author;
  @override
  @JsonKey(name: 'published_at')
  DateTime? get publishedAt;
  @override
  @JsonKey(name: 'likes_count')
  int get likesCount;
  @override
  @JsonKey(name: 'comments_count')
  int get commentsCount;

  /// Create a copy of PublicationDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PublicationDtoImplCopyWith<_$PublicationDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CommentDto _$CommentDtoFromJson(Map<String, dynamic> json) {
  return _CommentDto.fromJson(json);
}

/// @nodoc
mixin _$CommentDto {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'publication_id')
  String get publicationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this CommentDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommentDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentDtoCopyWith<CommentDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentDtoCopyWith<$Res> {
  factory $CommentDtoCopyWith(
    CommentDto value,
    $Res Function(CommentDto) then,
  ) = _$CommentDtoCopyWithImpl<$Res, CommentDto>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'publication_id') String publicationId,
    @JsonKey(name: 'user_id') String userId,
    String body,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class _$CommentDtoCopyWithImpl<$Res, $Val extends CommentDto>
    implements $CommentDtoCopyWith<$Res> {
  _$CommentDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommentDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? publicationId = null,
    Object? userId = null,
    Object? body = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            publicationId: null == publicationId
                ? _value.publicationId
                : publicationId // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            body: null == body
                ? _value.body
                : body // ignore: cast_nullable_to_non_nullable
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
abstract class _$$CommentDtoImplCopyWith<$Res>
    implements $CommentDtoCopyWith<$Res> {
  factory _$$CommentDtoImplCopyWith(
    _$CommentDtoImpl value,
    $Res Function(_$CommentDtoImpl) then,
  ) = __$$CommentDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'publication_id') String publicationId,
    @JsonKey(name: 'user_id') String userId,
    String body,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class __$$CommentDtoImplCopyWithImpl<$Res>
    extends _$CommentDtoCopyWithImpl<$Res, _$CommentDtoImpl>
    implements _$$CommentDtoImplCopyWith<$Res> {
  __$$CommentDtoImplCopyWithImpl(
    _$CommentDtoImpl _value,
    $Res Function(_$CommentDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CommentDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? publicationId = null,
    Object? userId = null,
    Object? body = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$CommentDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        publicationId: null == publicationId
            ? _value.publicationId
            : publicationId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        body: null == body
            ? _value.body
            : body // ignore: cast_nullable_to_non_nullable
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
class _$CommentDtoImpl implements _CommentDto {
  const _$CommentDtoImpl({
    required this.id,
    @JsonKey(name: 'publication_id') required this.publicationId,
    @JsonKey(name: 'user_id') required this.userId,
    this.body = '',
    @JsonKey(name: 'created_at') this.createdAt,
  });

  factory _$CommentDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommentDtoImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'publication_id')
  final String publicationId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey()
  final String body;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'CommentDto(id: $id, publicationId: $publicationId, userId: $userId, body: $body, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.publicationId, publicationId) ||
                other.publicationId == publicationId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, publicationId, userId, body, createdAt);

  /// Create a copy of CommentDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentDtoImplCopyWith<_$CommentDtoImpl> get copyWith =>
      __$$CommentDtoImplCopyWithImpl<_$CommentDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommentDtoImplToJson(this);
  }
}

abstract class _CommentDto implements CommentDto {
  const factory _CommentDto({
    required final String id,
    @JsonKey(name: 'publication_id') required final String publicationId,
    @JsonKey(name: 'user_id') required final String userId,
    final String body,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
  }) = _$CommentDtoImpl;

  factory _CommentDto.fromJson(Map<String, dynamic> json) =
      _$CommentDtoImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'publication_id')
  String get publicationId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get body;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of CommentDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentDtoImplCopyWith<_$CommentDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaginatedPublicationsDto _$PaginatedPublicationsDtoFromJson(
  Map<String, dynamic> json,
) {
  return _PaginatedPublicationsDto.fromJson(json);
}

/// @nodoc
mixin _$PaginatedPublicationsDto {
  List<PublicationDto> get items => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  @JsonKey(name: 'page_size')
  int get pageSize => throw _privateConstructorUsedError;

  /// Serializes this PaginatedPublicationsDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaginatedPublicationsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginatedPublicationsDtoCopyWith<PaginatedPublicationsDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginatedPublicationsDtoCopyWith<$Res> {
  factory $PaginatedPublicationsDtoCopyWith(
    PaginatedPublicationsDto value,
    $Res Function(PaginatedPublicationsDto) then,
  ) = _$PaginatedPublicationsDtoCopyWithImpl<$Res, PaginatedPublicationsDto>;
  @useResult
  $Res call({
    List<PublicationDto> items,
    int total,
    int page,
    @JsonKey(name: 'page_size') int pageSize,
  });
}

/// @nodoc
class _$PaginatedPublicationsDtoCopyWithImpl<
  $Res,
  $Val extends PaginatedPublicationsDto
>
    implements $PaginatedPublicationsDtoCopyWith<$Res> {
  _$PaginatedPublicationsDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginatedPublicationsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? total = null,
    Object? page = null,
    Object? pageSize = null,
  }) {
    return _then(
      _value.copyWith(
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<PublicationDto>,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
            page: null == page
                ? _value.page
                : page // ignore: cast_nullable_to_non_nullable
                      as int,
            pageSize: null == pageSize
                ? _value.pageSize
                : pageSize // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaginatedPublicationsDtoImplCopyWith<$Res>
    implements $PaginatedPublicationsDtoCopyWith<$Res> {
  factory _$$PaginatedPublicationsDtoImplCopyWith(
    _$PaginatedPublicationsDtoImpl value,
    $Res Function(_$PaginatedPublicationsDtoImpl) then,
  ) = __$$PaginatedPublicationsDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<PublicationDto> items,
    int total,
    int page,
    @JsonKey(name: 'page_size') int pageSize,
  });
}

/// @nodoc
class __$$PaginatedPublicationsDtoImplCopyWithImpl<$Res>
    extends
        _$PaginatedPublicationsDtoCopyWithImpl<
          $Res,
          _$PaginatedPublicationsDtoImpl
        >
    implements _$$PaginatedPublicationsDtoImplCopyWith<$Res> {
  __$$PaginatedPublicationsDtoImplCopyWithImpl(
    _$PaginatedPublicationsDtoImpl _value,
    $Res Function(_$PaginatedPublicationsDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaginatedPublicationsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? total = null,
    Object? page = null,
    Object? pageSize = null,
  }) {
    return _then(
      _$PaginatedPublicationsDtoImpl(
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<PublicationDto>,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        page: null == page
            ? _value.page
            : page // ignore: cast_nullable_to_non_nullable
                  as int,
        pageSize: null == pageSize
            ? _value.pageSize
            : pageSize // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginatedPublicationsDtoImpl implements _PaginatedPublicationsDto {
  const _$PaginatedPublicationsDtoImpl({
    final List<PublicationDto> items = const <PublicationDto>[],
    this.total = 0,
    this.page = 1,
    @JsonKey(name: 'page_size') this.pageSize = 20,
  }) : _items = items;

  factory _$PaginatedPublicationsDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginatedPublicationsDtoImplFromJson(json);

  final List<PublicationDto> _items;
  @override
  @JsonKey()
  List<PublicationDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey()
  final int total;
  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey(name: 'page_size')
  final int pageSize;

  @override
  String toString() {
    return 'PaginatedPublicationsDto(items: $items, total: $total, page: $page, pageSize: $pageSize)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginatedPublicationsDtoImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_items),
    total,
    page,
    pageSize,
  );

  /// Create a copy of PaginatedPublicationsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginatedPublicationsDtoImplCopyWith<_$PaginatedPublicationsDtoImpl>
  get copyWith =>
      __$$PaginatedPublicationsDtoImplCopyWithImpl<
        _$PaginatedPublicationsDtoImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginatedPublicationsDtoImplToJson(this);
  }
}

abstract class _PaginatedPublicationsDto implements PaginatedPublicationsDto {
  const factory _PaginatedPublicationsDto({
    final List<PublicationDto> items,
    final int total,
    final int page,
    @JsonKey(name: 'page_size') final int pageSize,
  }) = _$PaginatedPublicationsDtoImpl;

  factory _PaginatedPublicationsDto.fromJson(Map<String, dynamic> json) =
      _$PaginatedPublicationsDtoImpl.fromJson;

  @override
  List<PublicationDto> get items;
  @override
  int get total;
  @override
  int get page;
  @override
  @JsonKey(name: 'page_size')
  int get pageSize;

  /// Create a copy of PaginatedPublicationsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginatedPublicationsDtoImplCopyWith<_$PaginatedPublicationsDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}
