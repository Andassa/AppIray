// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CourseDto _$CourseDtoFromJson(Map<String, dynamic> json) {
  return _CourseDto.fromJson(json);
}

/// @nodoc
mixin _$CourseDto {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_language')
  String get targetLanguage => throw _privateConstructorUsedError;
  @JsonKey(name: 'source_language')
  String get sourceLanguage => throw _privateConstructorUsedError;

  /// Serializes this CourseDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CourseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CourseDtoCopyWith<CourseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseDtoCopyWith<$Res> {
  factory $CourseDtoCopyWith(CourseDto value, $Res Function(CourseDto) then) =
      _$CourseDtoCopyWithImpl<$Res, CourseDto>;
  @useResult
  $Res call({
    String id,
    String title,
    String? description,
    @JsonKey(name: 'target_language') String targetLanguage,
    @JsonKey(name: 'source_language') String sourceLanguage,
  });
}

/// @nodoc
class _$CourseDtoCopyWithImpl<$Res, $Val extends CourseDto>
    implements $CourseDtoCopyWith<$Res> {
  _$CourseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CourseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? targetLanguage = null,
    Object? sourceLanguage = null,
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
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            targetLanguage: null == targetLanguage
                ? _value.targetLanguage
                : targetLanguage // ignore: cast_nullable_to_non_nullable
                      as String,
            sourceLanguage: null == sourceLanguage
                ? _value.sourceLanguage
                : sourceLanguage // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CourseDtoImplCopyWith<$Res>
    implements $CourseDtoCopyWith<$Res> {
  factory _$$CourseDtoImplCopyWith(
    _$CourseDtoImpl value,
    $Res Function(_$CourseDtoImpl) then,
  ) = __$$CourseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String? description,
    @JsonKey(name: 'target_language') String targetLanguage,
    @JsonKey(name: 'source_language') String sourceLanguage,
  });
}

/// @nodoc
class __$$CourseDtoImplCopyWithImpl<$Res>
    extends _$CourseDtoCopyWithImpl<$Res, _$CourseDtoImpl>
    implements _$$CourseDtoImplCopyWith<$Res> {
  __$$CourseDtoImplCopyWithImpl(
    _$CourseDtoImpl _value,
    $Res Function(_$CourseDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CourseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? targetLanguage = null,
    Object? sourceLanguage = null,
  }) {
    return _then(
      _$CourseDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        targetLanguage: null == targetLanguage
            ? _value.targetLanguage
            : targetLanguage // ignore: cast_nullable_to_non_nullable
                  as String,
        sourceLanguage: null == sourceLanguage
            ? _value.sourceLanguage
            : sourceLanguage // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CourseDtoImpl implements _CourseDto {
  const _$CourseDtoImpl({
    required this.id,
    required this.title,
    this.description,
    @JsonKey(name: 'target_language') this.targetLanguage = 'malagasy',
    @JsonKey(name: 'source_language') this.sourceLanguage = 'français',
  });

  factory _$CourseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourseDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey(name: 'target_language')
  final String targetLanguage;
  @override
  @JsonKey(name: 'source_language')
  final String sourceLanguage;

  @override
  String toString() {
    return 'CourseDto(id: $id, title: $title, description: $description, targetLanguage: $targetLanguage, sourceLanguage: $sourceLanguage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.targetLanguage, targetLanguage) ||
                other.targetLanguage == targetLanguage) &&
            (identical(other.sourceLanguage, sourceLanguage) ||
                other.sourceLanguage == sourceLanguage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    targetLanguage,
    sourceLanguage,
  );

  /// Create a copy of CourseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseDtoImplCopyWith<_$CourseDtoImpl> get copyWith =>
      __$$CourseDtoImplCopyWithImpl<_$CourseDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CourseDtoImplToJson(this);
  }
}

abstract class _CourseDto implements CourseDto {
  const factory _CourseDto({
    required final String id,
    required final String title,
    final String? description,
    @JsonKey(name: 'target_language') final String targetLanguage,
    @JsonKey(name: 'source_language') final String sourceLanguage,
  }) = _$CourseDtoImpl;

  factory _CourseDto.fromJson(Map<String, dynamic> json) =
      _$CourseDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  @JsonKey(name: 'target_language')
  String get targetLanguage;
  @override
  @JsonKey(name: 'source_language')
  String get sourceLanguage;

  /// Create a copy of CourseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CourseDtoImplCopyWith<_$CourseDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LessonDto _$LessonDtoFromJson(Map<String, dynamic> json) {
  return _LessonDto.fromJson(json);
}

/// @nodoc
mixin _$LessonDto {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_id')
  String get unitId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  @JsonKey(name: 'xp_reward')
  int get xpReward => throw _privateConstructorUsedError;

  /// Serializes this LessonDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LessonDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LessonDtoCopyWith<LessonDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LessonDtoCopyWith<$Res> {
  factory $LessonDtoCopyWith(LessonDto value, $Res Function(LessonDto) then) =
      _$LessonDtoCopyWithImpl<$Res, LessonDto>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'unit_id') String unitId,
    String title,
    int order,
    @JsonKey(name: 'xp_reward') int xpReward,
  });
}

/// @nodoc
class _$LessonDtoCopyWithImpl<$Res, $Val extends LessonDto>
    implements $LessonDtoCopyWith<$Res> {
  _$LessonDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LessonDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? unitId = null,
    Object? title = null,
    Object? order = null,
    Object? xpReward = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            unitId: null == unitId
                ? _value.unitId
                : unitId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            order: null == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as int,
            xpReward: null == xpReward
                ? _value.xpReward
                : xpReward // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LessonDtoImplCopyWith<$Res>
    implements $LessonDtoCopyWith<$Res> {
  factory _$$LessonDtoImplCopyWith(
    _$LessonDtoImpl value,
    $Res Function(_$LessonDtoImpl) then,
  ) = __$$LessonDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'unit_id') String unitId,
    String title,
    int order,
    @JsonKey(name: 'xp_reward') int xpReward,
  });
}

/// @nodoc
class __$$LessonDtoImplCopyWithImpl<$Res>
    extends _$LessonDtoCopyWithImpl<$Res, _$LessonDtoImpl>
    implements _$$LessonDtoImplCopyWith<$Res> {
  __$$LessonDtoImplCopyWithImpl(
    _$LessonDtoImpl _value,
    $Res Function(_$LessonDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LessonDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? unitId = null,
    Object? title = null,
    Object? order = null,
    Object? xpReward = null,
  }) {
    return _then(
      _$LessonDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        unitId: null == unitId
            ? _value.unitId
            : unitId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        order: null == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as int,
        xpReward: null == xpReward
            ? _value.xpReward
            : xpReward // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LessonDtoImpl implements _LessonDto {
  const _$LessonDtoImpl({
    required this.id,
    @JsonKey(name: 'unit_id') required this.unitId,
    required this.title,
    this.order = 0,
    @JsonKey(name: 'xp_reward') this.xpReward = 0,
  });

  factory _$LessonDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$LessonDtoImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'unit_id')
  final String unitId;
  @override
  final String title;
  @override
  @JsonKey()
  final int order;
  @override
  @JsonKey(name: 'xp_reward')
  final int xpReward;

  @override
  String toString() {
    return 'LessonDto(id: $id, unitId: $unitId, title: $title, order: $order, xpReward: $xpReward)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LessonDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.unitId, unitId) || other.unitId == unitId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.xpReward, xpReward) ||
                other.xpReward == xpReward));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, unitId, title, order, xpReward);

  /// Create a copy of LessonDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LessonDtoImplCopyWith<_$LessonDtoImpl> get copyWith =>
      __$$LessonDtoImplCopyWithImpl<_$LessonDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LessonDtoImplToJson(this);
  }
}

abstract class _LessonDto implements LessonDto {
  const factory _LessonDto({
    required final String id,
    @JsonKey(name: 'unit_id') required final String unitId,
    required final String title,
    final int order,
    @JsonKey(name: 'xp_reward') final int xpReward,
  }) = _$LessonDtoImpl;

  factory _LessonDto.fromJson(Map<String, dynamic> json) =
      _$LessonDtoImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'unit_id')
  String get unitId;
  @override
  String get title;
  @override
  int get order;
  @override
  @JsonKey(name: 'xp_reward')
  int get xpReward;

  /// Create a copy of LessonDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LessonDtoImplCopyWith<_$LessonDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UnitDetailDto _$UnitDetailDtoFromJson(Map<String, dynamic> json) {
  return _UnitDetailDto.fromJson(json);
}

/// @nodoc
mixin _$UnitDetailDto {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'course_id')
  String get courseId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  List<LessonDto> get lessons => throw _privateConstructorUsedError;

  /// Serializes this UnitDetailDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UnitDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UnitDetailDtoCopyWith<UnitDetailDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnitDetailDtoCopyWith<$Res> {
  factory $UnitDetailDtoCopyWith(
    UnitDetailDto value,
    $Res Function(UnitDetailDto) then,
  ) = _$UnitDetailDtoCopyWithImpl<$Res, UnitDetailDto>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'course_id') String courseId,
    String title,
    int order,
    List<LessonDto> lessons,
  });
}

/// @nodoc
class _$UnitDetailDtoCopyWithImpl<$Res, $Val extends UnitDetailDto>
    implements $UnitDetailDtoCopyWith<$Res> {
  _$UnitDetailDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UnitDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? courseId = null,
    Object? title = null,
    Object? order = null,
    Object? lessons = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            courseId: null == courseId
                ? _value.courseId
                : courseId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            order: null == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as int,
            lessons: null == lessons
                ? _value.lessons
                : lessons // ignore: cast_nullable_to_non_nullable
                      as List<LessonDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UnitDetailDtoImplCopyWith<$Res>
    implements $UnitDetailDtoCopyWith<$Res> {
  factory _$$UnitDetailDtoImplCopyWith(
    _$UnitDetailDtoImpl value,
    $Res Function(_$UnitDetailDtoImpl) then,
  ) = __$$UnitDetailDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'course_id') String courseId,
    String title,
    int order,
    List<LessonDto> lessons,
  });
}

/// @nodoc
class __$$UnitDetailDtoImplCopyWithImpl<$Res>
    extends _$UnitDetailDtoCopyWithImpl<$Res, _$UnitDetailDtoImpl>
    implements _$$UnitDetailDtoImplCopyWith<$Res> {
  __$$UnitDetailDtoImplCopyWithImpl(
    _$UnitDetailDtoImpl _value,
    $Res Function(_$UnitDetailDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UnitDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? courseId = null,
    Object? title = null,
    Object? order = null,
    Object? lessons = null,
  }) {
    return _then(
      _$UnitDetailDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        courseId: null == courseId
            ? _value.courseId
            : courseId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        order: null == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as int,
        lessons: null == lessons
            ? _value._lessons
            : lessons // ignore: cast_nullable_to_non_nullable
                  as List<LessonDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UnitDetailDtoImpl implements _UnitDetailDto {
  const _$UnitDetailDtoImpl({
    required this.id,
    @JsonKey(name: 'course_id') required this.courseId,
    required this.title,
    this.order = 0,
    final List<LessonDto> lessons = const <LessonDto>[],
  }) : _lessons = lessons;

  factory _$UnitDetailDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UnitDetailDtoImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'course_id')
  final String courseId;
  @override
  final String title;
  @override
  @JsonKey()
  final int order;
  final List<LessonDto> _lessons;
  @override
  @JsonKey()
  List<LessonDto> get lessons {
    if (_lessons is EqualUnmodifiableListView) return _lessons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lessons);
  }

  @override
  String toString() {
    return 'UnitDetailDto(id: $id, courseId: $courseId, title: $title, order: $order, lessons: $lessons)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnitDetailDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.order, order) || other.order == order) &&
            const DeepCollectionEquality().equals(other._lessons, _lessons));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    courseId,
    title,
    order,
    const DeepCollectionEquality().hash(_lessons),
  );

  /// Create a copy of UnitDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnitDetailDtoImplCopyWith<_$UnitDetailDtoImpl> get copyWith =>
      __$$UnitDetailDtoImplCopyWithImpl<_$UnitDetailDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UnitDetailDtoImplToJson(this);
  }
}

abstract class _UnitDetailDto implements UnitDetailDto {
  const factory _UnitDetailDto({
    required final String id,
    @JsonKey(name: 'course_id') required final String courseId,
    required final String title,
    final int order,
    final List<LessonDto> lessons,
  }) = _$UnitDetailDtoImpl;

  factory _UnitDetailDto.fromJson(Map<String, dynamic> json) =
      _$UnitDetailDtoImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'course_id')
  String get courseId;
  @override
  String get title;
  @override
  int get order;
  @override
  List<LessonDto> get lessons;

  /// Create a copy of UnitDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnitDetailDtoImplCopyWith<_$UnitDetailDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CourseDetailDto _$CourseDetailDtoFromJson(Map<String, dynamic> json) {
  return _CourseDetailDto.fromJson(json);
}

/// @nodoc
mixin _$CourseDetailDto {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_language')
  String get targetLanguage => throw _privateConstructorUsedError;
  @JsonKey(name: 'source_language')
  String get sourceLanguage => throw _privateConstructorUsedError;
  List<UnitDetailDto> get units => throw _privateConstructorUsedError;

  /// Serializes this CourseDetailDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CourseDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CourseDetailDtoCopyWith<CourseDetailDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseDetailDtoCopyWith<$Res> {
  factory $CourseDetailDtoCopyWith(
    CourseDetailDto value,
    $Res Function(CourseDetailDto) then,
  ) = _$CourseDetailDtoCopyWithImpl<$Res, CourseDetailDto>;
  @useResult
  $Res call({
    String id,
    String title,
    String? description,
    @JsonKey(name: 'target_language') String targetLanguage,
    @JsonKey(name: 'source_language') String sourceLanguage,
    List<UnitDetailDto> units,
  });
}

/// @nodoc
class _$CourseDetailDtoCopyWithImpl<$Res, $Val extends CourseDetailDto>
    implements $CourseDetailDtoCopyWith<$Res> {
  _$CourseDetailDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CourseDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? targetLanguage = null,
    Object? sourceLanguage = null,
    Object? units = null,
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
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            targetLanguage: null == targetLanguage
                ? _value.targetLanguage
                : targetLanguage // ignore: cast_nullable_to_non_nullable
                      as String,
            sourceLanguage: null == sourceLanguage
                ? _value.sourceLanguage
                : sourceLanguage // ignore: cast_nullable_to_non_nullable
                      as String,
            units: null == units
                ? _value.units
                : units // ignore: cast_nullable_to_non_nullable
                      as List<UnitDetailDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CourseDetailDtoImplCopyWith<$Res>
    implements $CourseDetailDtoCopyWith<$Res> {
  factory _$$CourseDetailDtoImplCopyWith(
    _$CourseDetailDtoImpl value,
    $Res Function(_$CourseDetailDtoImpl) then,
  ) = __$$CourseDetailDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String? description,
    @JsonKey(name: 'target_language') String targetLanguage,
    @JsonKey(name: 'source_language') String sourceLanguage,
    List<UnitDetailDto> units,
  });
}

/// @nodoc
class __$$CourseDetailDtoImplCopyWithImpl<$Res>
    extends _$CourseDetailDtoCopyWithImpl<$Res, _$CourseDetailDtoImpl>
    implements _$$CourseDetailDtoImplCopyWith<$Res> {
  __$$CourseDetailDtoImplCopyWithImpl(
    _$CourseDetailDtoImpl _value,
    $Res Function(_$CourseDetailDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CourseDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? targetLanguage = null,
    Object? sourceLanguage = null,
    Object? units = null,
  }) {
    return _then(
      _$CourseDetailDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        targetLanguage: null == targetLanguage
            ? _value.targetLanguage
            : targetLanguage // ignore: cast_nullable_to_non_nullable
                  as String,
        sourceLanguage: null == sourceLanguage
            ? _value.sourceLanguage
            : sourceLanguage // ignore: cast_nullable_to_non_nullable
                  as String,
        units: null == units
            ? _value._units
            : units // ignore: cast_nullable_to_non_nullable
                  as List<UnitDetailDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CourseDetailDtoImpl implements _CourseDetailDto {
  const _$CourseDetailDtoImpl({
    required this.id,
    required this.title,
    this.description,
    @JsonKey(name: 'target_language') this.targetLanguage = 'malagasy',
    @JsonKey(name: 'source_language') this.sourceLanguage = 'français',
    final List<UnitDetailDto> units = const <UnitDetailDto>[],
  }) : _units = units;

  factory _$CourseDetailDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourseDetailDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey(name: 'target_language')
  final String targetLanguage;
  @override
  @JsonKey(name: 'source_language')
  final String sourceLanguage;
  final List<UnitDetailDto> _units;
  @override
  @JsonKey()
  List<UnitDetailDto> get units {
    if (_units is EqualUnmodifiableListView) return _units;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_units);
  }

  @override
  String toString() {
    return 'CourseDetailDto(id: $id, title: $title, description: $description, targetLanguage: $targetLanguage, sourceLanguage: $sourceLanguage, units: $units)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseDetailDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.targetLanguage, targetLanguage) ||
                other.targetLanguage == targetLanguage) &&
            (identical(other.sourceLanguage, sourceLanguage) ||
                other.sourceLanguage == sourceLanguage) &&
            const DeepCollectionEquality().equals(other._units, _units));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    targetLanguage,
    sourceLanguage,
    const DeepCollectionEquality().hash(_units),
  );

  /// Create a copy of CourseDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseDetailDtoImplCopyWith<_$CourseDetailDtoImpl> get copyWith =>
      __$$CourseDetailDtoImplCopyWithImpl<_$CourseDetailDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CourseDetailDtoImplToJson(this);
  }
}

abstract class _CourseDetailDto implements CourseDetailDto {
  const factory _CourseDetailDto({
    required final String id,
    required final String title,
    final String? description,
    @JsonKey(name: 'target_language') final String targetLanguage,
    @JsonKey(name: 'source_language') final String sourceLanguage,
    final List<UnitDetailDto> units,
  }) = _$CourseDetailDtoImpl;

  factory _CourseDetailDto.fromJson(Map<String, dynamic> json) =
      _$CourseDetailDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  @JsonKey(name: 'target_language')
  String get targetLanguage;
  @override
  @JsonKey(name: 'source_language')
  String get sourceLanguage;
  @override
  List<UnitDetailDto> get units;

  /// Create a copy of CourseDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CourseDetailDtoImplCopyWith<_$CourseDetailDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
