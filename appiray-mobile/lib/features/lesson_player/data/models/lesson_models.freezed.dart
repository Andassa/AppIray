// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ExerciseDto _$ExerciseDtoFromJson(Map<String, dynamic> json) {
  return _ExerciseDto.fromJson(json);
}

/// @nodoc
mixin _$ExerciseDto {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'lesson_id')
  String get lessonId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  Map<String, dynamic> get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'audio_asset_id')
  String? get audioAssetId => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;

  /// Serializes this ExerciseDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExerciseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExerciseDtoCopyWith<ExerciseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExerciseDtoCopyWith<$Res> {
  factory $ExerciseDtoCopyWith(
    ExerciseDto value,
    $Res Function(ExerciseDto) then,
  ) = _$ExerciseDtoCopyWithImpl<$Res, ExerciseDto>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'lesson_id') String lessonId,
    String type,
    Map<String, dynamic> content,
    @JsonKey(name: 'audio_asset_id') String? audioAssetId,
    int order,
  });
}

/// @nodoc
class _$ExerciseDtoCopyWithImpl<$Res, $Val extends ExerciseDto>
    implements $ExerciseDtoCopyWith<$Res> {
  _$ExerciseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExerciseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? lessonId = null,
    Object? type = null,
    Object? content = null,
    Object? audioAssetId = freezed,
    Object? order = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            lessonId: null == lessonId
                ? _value.lessonId
                : lessonId // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            audioAssetId: freezed == audioAssetId
                ? _value.audioAssetId
                : audioAssetId // ignore: cast_nullable_to_non_nullable
                      as String?,
            order: null == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExerciseDtoImplCopyWith<$Res>
    implements $ExerciseDtoCopyWith<$Res> {
  factory _$$ExerciseDtoImplCopyWith(
    _$ExerciseDtoImpl value,
    $Res Function(_$ExerciseDtoImpl) then,
  ) = __$$ExerciseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'lesson_id') String lessonId,
    String type,
    Map<String, dynamic> content,
    @JsonKey(name: 'audio_asset_id') String? audioAssetId,
    int order,
  });
}

/// @nodoc
class __$$ExerciseDtoImplCopyWithImpl<$Res>
    extends _$ExerciseDtoCopyWithImpl<$Res, _$ExerciseDtoImpl>
    implements _$$ExerciseDtoImplCopyWith<$Res> {
  __$$ExerciseDtoImplCopyWithImpl(
    _$ExerciseDtoImpl _value,
    $Res Function(_$ExerciseDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExerciseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? lessonId = null,
    Object? type = null,
    Object? content = null,
    Object? audioAssetId = freezed,
    Object? order = null,
  }) {
    return _then(
      _$ExerciseDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        lessonId: null == lessonId
            ? _value.lessonId
            : lessonId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value._content
            : content // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        audioAssetId: freezed == audioAssetId
            ? _value.audioAssetId
            : audioAssetId // ignore: cast_nullable_to_non_nullable
                  as String?,
        order: null == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExerciseDtoImpl implements _ExerciseDto {
  const _$ExerciseDtoImpl({
    required this.id,
    @JsonKey(name: 'lesson_id') required this.lessonId,
    required this.type,
    final Map<String, dynamic> content = const <String, dynamic>{},
    @JsonKey(name: 'audio_asset_id') this.audioAssetId,
    this.order = 0,
  }) : _content = content;

  factory _$ExerciseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExerciseDtoImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'lesson_id')
  final String lessonId;
  @override
  final String type;
  final Map<String, dynamic> _content;
  @override
  @JsonKey()
  Map<String, dynamic> get content {
    if (_content is EqualUnmodifiableMapView) return _content;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_content);
  }

  @override
  @JsonKey(name: 'audio_asset_id')
  final String? audioAssetId;
  @override
  @JsonKey()
  final int order;

  @override
  String toString() {
    return 'ExerciseDto(id: $id, lessonId: $lessonId, type: $type, content: $content, audioAssetId: $audioAssetId, order: $order)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExerciseDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.lessonId, lessonId) ||
                other.lessonId == lessonId) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._content, _content) &&
            (identical(other.audioAssetId, audioAssetId) ||
                other.audioAssetId == audioAssetId) &&
            (identical(other.order, order) || other.order == order));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    lessonId,
    type,
    const DeepCollectionEquality().hash(_content),
    audioAssetId,
    order,
  );

  /// Create a copy of ExerciseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExerciseDtoImplCopyWith<_$ExerciseDtoImpl> get copyWith =>
      __$$ExerciseDtoImplCopyWithImpl<_$ExerciseDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExerciseDtoImplToJson(this);
  }
}

abstract class _ExerciseDto implements ExerciseDto {
  const factory _ExerciseDto({
    required final String id,
    @JsonKey(name: 'lesson_id') required final String lessonId,
    required final String type,
    final Map<String, dynamic> content,
    @JsonKey(name: 'audio_asset_id') final String? audioAssetId,
    final int order,
  }) = _$ExerciseDtoImpl;

  factory _ExerciseDto.fromJson(Map<String, dynamic> json) =
      _$ExerciseDtoImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'lesson_id')
  String get lessonId;
  @override
  String get type;
  @override
  Map<String, dynamic> get content;
  @override
  @JsonKey(name: 'audio_asset_id')
  String? get audioAssetId;
  @override
  int get order;

  /// Create a copy of ExerciseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExerciseDtoImplCopyWith<_$ExerciseDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LessonDetailDto _$LessonDetailDtoFromJson(Map<String, dynamic> json) {
  return _LessonDetailDto.fromJson(json);
}

/// @nodoc
mixin _$LessonDetailDto {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_id')
  String get unitId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  @JsonKey(name: 'xp_reward')
  int get xpReward => throw _privateConstructorUsedError;
  List<ExerciseDto> get exercises => throw _privateConstructorUsedError;

  /// Serializes this LessonDetailDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LessonDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LessonDetailDtoCopyWith<LessonDetailDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LessonDetailDtoCopyWith<$Res> {
  factory $LessonDetailDtoCopyWith(
    LessonDetailDto value,
    $Res Function(LessonDetailDto) then,
  ) = _$LessonDetailDtoCopyWithImpl<$Res, LessonDetailDto>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'unit_id') String unitId,
    String title,
    int order,
    @JsonKey(name: 'xp_reward') int xpReward,
    List<ExerciseDto> exercises,
  });
}

/// @nodoc
class _$LessonDetailDtoCopyWithImpl<$Res, $Val extends LessonDetailDto>
    implements $LessonDetailDtoCopyWith<$Res> {
  _$LessonDetailDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LessonDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? unitId = null,
    Object? title = null,
    Object? order = null,
    Object? xpReward = null,
    Object? exercises = null,
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
            exercises: null == exercises
                ? _value.exercises
                : exercises // ignore: cast_nullable_to_non_nullable
                      as List<ExerciseDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LessonDetailDtoImplCopyWith<$Res>
    implements $LessonDetailDtoCopyWith<$Res> {
  factory _$$LessonDetailDtoImplCopyWith(
    _$LessonDetailDtoImpl value,
    $Res Function(_$LessonDetailDtoImpl) then,
  ) = __$$LessonDetailDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'unit_id') String unitId,
    String title,
    int order,
    @JsonKey(name: 'xp_reward') int xpReward,
    List<ExerciseDto> exercises,
  });
}

/// @nodoc
class __$$LessonDetailDtoImplCopyWithImpl<$Res>
    extends _$LessonDetailDtoCopyWithImpl<$Res, _$LessonDetailDtoImpl>
    implements _$$LessonDetailDtoImplCopyWith<$Res> {
  __$$LessonDetailDtoImplCopyWithImpl(
    _$LessonDetailDtoImpl _value,
    $Res Function(_$LessonDetailDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LessonDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? unitId = null,
    Object? title = null,
    Object? order = null,
    Object? xpReward = null,
    Object? exercises = null,
  }) {
    return _then(
      _$LessonDetailDtoImpl(
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
        exercises: null == exercises
            ? _value._exercises
            : exercises // ignore: cast_nullable_to_non_nullable
                  as List<ExerciseDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LessonDetailDtoImpl implements _LessonDetailDto {
  const _$LessonDetailDtoImpl({
    required this.id,
    @JsonKey(name: 'unit_id') required this.unitId,
    required this.title,
    this.order = 0,
    @JsonKey(name: 'xp_reward') this.xpReward = 0,
    final List<ExerciseDto> exercises = const <ExerciseDto>[],
  }) : _exercises = exercises;

  factory _$LessonDetailDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$LessonDetailDtoImplFromJson(json);

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
  final List<ExerciseDto> _exercises;
  @override
  @JsonKey()
  List<ExerciseDto> get exercises {
    if (_exercises is EqualUnmodifiableListView) return _exercises;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exercises);
  }

  @override
  String toString() {
    return 'LessonDetailDto(id: $id, unitId: $unitId, title: $title, order: $order, xpReward: $xpReward, exercises: $exercises)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LessonDetailDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.unitId, unitId) || other.unitId == unitId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.xpReward, xpReward) ||
                other.xpReward == xpReward) &&
            const DeepCollectionEquality().equals(
              other._exercises,
              _exercises,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    unitId,
    title,
    order,
    xpReward,
    const DeepCollectionEquality().hash(_exercises),
  );

  /// Create a copy of LessonDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LessonDetailDtoImplCopyWith<_$LessonDetailDtoImpl> get copyWith =>
      __$$LessonDetailDtoImplCopyWithImpl<_$LessonDetailDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LessonDetailDtoImplToJson(this);
  }
}

abstract class _LessonDetailDto implements LessonDetailDto {
  const factory _LessonDetailDto({
    required final String id,
    @JsonKey(name: 'unit_id') required final String unitId,
    required final String title,
    final int order,
    @JsonKey(name: 'xp_reward') final int xpReward,
    final List<ExerciseDto> exercises,
  }) = _$LessonDetailDtoImpl;

  factory _LessonDetailDto.fromJson(Map<String, dynamic> json) =
      _$LessonDetailDtoImpl.fromJson;

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
  @override
  List<ExerciseDto> get exercises;

  /// Create a copy of LessonDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LessonDetailDtoImplCopyWith<_$LessonDetailDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AnswerResultDto _$AnswerResultDtoFromJson(Map<String, dynamic> json) {
  return _AnswerResultDto.fromJson(json);
}

/// @nodoc
mixin _$AnswerResultDto {
  @JsonKey(name: 'is_correct')
  bool get isCorrect => throw _privateConstructorUsedError;
  @JsonKey(name: 'xp_gained')
  int get xpGained => throw _privateConstructorUsedError;
  @JsonKey(name: 'gems_gained')
  int get gemsGained => throw _privateConstructorUsedError;
  int get hearts => throw _privateConstructorUsedError;
  @JsonKey(name: 'xp_total')
  int get xpTotal => throw _privateConstructorUsedError;
  int get gems => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_streak')
  int get currentStreak => throw _privateConstructorUsedError;
  int get level => throw _privateConstructorUsedError;
  @JsonKey(name: 'lesson_completed')
  bool get lessonCompleted => throw _privateConstructorUsedError;
  @JsonKey(name: 'daily_goal_reached')
  bool get dailyGoalReached => throw _privateConstructorUsedError;

  /// Serializes this AnswerResultDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnswerResultDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnswerResultDtoCopyWith<AnswerResultDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnswerResultDtoCopyWith<$Res> {
  factory $AnswerResultDtoCopyWith(
    AnswerResultDto value,
    $Res Function(AnswerResultDto) then,
  ) = _$AnswerResultDtoCopyWithImpl<$Res, AnswerResultDto>;
  @useResult
  $Res call({
    @JsonKey(name: 'is_correct') bool isCorrect,
    @JsonKey(name: 'xp_gained') int xpGained,
    @JsonKey(name: 'gems_gained') int gemsGained,
    int hearts,
    @JsonKey(name: 'xp_total') int xpTotal,
    int gems,
    @JsonKey(name: 'current_streak') int currentStreak,
    int level,
    @JsonKey(name: 'lesson_completed') bool lessonCompleted,
    @JsonKey(name: 'daily_goal_reached') bool dailyGoalReached,
  });
}

/// @nodoc
class _$AnswerResultDtoCopyWithImpl<$Res, $Val extends AnswerResultDto>
    implements $AnswerResultDtoCopyWith<$Res> {
  _$AnswerResultDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnswerResultDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCorrect = null,
    Object? xpGained = null,
    Object? gemsGained = null,
    Object? hearts = null,
    Object? xpTotal = null,
    Object? gems = null,
    Object? currentStreak = null,
    Object? level = null,
    Object? lessonCompleted = null,
    Object? dailyGoalReached = null,
  }) {
    return _then(
      _value.copyWith(
            isCorrect: null == isCorrect
                ? _value.isCorrect
                : isCorrect // ignore: cast_nullable_to_non_nullable
                      as bool,
            xpGained: null == xpGained
                ? _value.xpGained
                : xpGained // ignore: cast_nullable_to_non_nullable
                      as int,
            gemsGained: null == gemsGained
                ? _value.gemsGained
                : gemsGained // ignore: cast_nullable_to_non_nullable
                      as int,
            hearts: null == hearts
                ? _value.hearts
                : hearts // ignore: cast_nullable_to_non_nullable
                      as int,
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
            level: null == level
                ? _value.level
                : level // ignore: cast_nullable_to_non_nullable
                      as int,
            lessonCompleted: null == lessonCompleted
                ? _value.lessonCompleted
                : lessonCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            dailyGoalReached: null == dailyGoalReached
                ? _value.dailyGoalReached
                : dailyGoalReached // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnswerResultDtoImplCopyWith<$Res>
    implements $AnswerResultDtoCopyWith<$Res> {
  factory _$$AnswerResultDtoImplCopyWith(
    _$AnswerResultDtoImpl value,
    $Res Function(_$AnswerResultDtoImpl) then,
  ) = __$$AnswerResultDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'is_correct') bool isCorrect,
    @JsonKey(name: 'xp_gained') int xpGained,
    @JsonKey(name: 'gems_gained') int gemsGained,
    int hearts,
    @JsonKey(name: 'xp_total') int xpTotal,
    int gems,
    @JsonKey(name: 'current_streak') int currentStreak,
    int level,
    @JsonKey(name: 'lesson_completed') bool lessonCompleted,
    @JsonKey(name: 'daily_goal_reached') bool dailyGoalReached,
  });
}

/// @nodoc
class __$$AnswerResultDtoImplCopyWithImpl<$Res>
    extends _$AnswerResultDtoCopyWithImpl<$Res, _$AnswerResultDtoImpl>
    implements _$$AnswerResultDtoImplCopyWith<$Res> {
  __$$AnswerResultDtoImplCopyWithImpl(
    _$AnswerResultDtoImpl _value,
    $Res Function(_$AnswerResultDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnswerResultDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCorrect = null,
    Object? xpGained = null,
    Object? gemsGained = null,
    Object? hearts = null,
    Object? xpTotal = null,
    Object? gems = null,
    Object? currentStreak = null,
    Object? level = null,
    Object? lessonCompleted = null,
    Object? dailyGoalReached = null,
  }) {
    return _then(
      _$AnswerResultDtoImpl(
        isCorrect: null == isCorrect
            ? _value.isCorrect
            : isCorrect // ignore: cast_nullable_to_non_nullable
                  as bool,
        xpGained: null == xpGained
            ? _value.xpGained
            : xpGained // ignore: cast_nullable_to_non_nullable
                  as int,
        gemsGained: null == gemsGained
            ? _value.gemsGained
            : gemsGained // ignore: cast_nullable_to_non_nullable
                  as int,
        hearts: null == hearts
            ? _value.hearts
            : hearts // ignore: cast_nullable_to_non_nullable
                  as int,
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
        level: null == level
            ? _value.level
            : level // ignore: cast_nullable_to_non_nullable
                  as int,
        lessonCompleted: null == lessonCompleted
            ? _value.lessonCompleted
            : lessonCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        dailyGoalReached: null == dailyGoalReached
            ? _value.dailyGoalReached
            : dailyGoalReached // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnswerResultDtoImpl implements _AnswerResultDto {
  const _$AnswerResultDtoImpl({
    @JsonKey(name: 'is_correct') required this.isCorrect,
    @JsonKey(name: 'xp_gained') this.xpGained = 0,
    @JsonKey(name: 'gems_gained') this.gemsGained = 0,
    this.hearts = 0,
    @JsonKey(name: 'xp_total') this.xpTotal = 0,
    this.gems = 0,
    @JsonKey(name: 'current_streak') this.currentStreak = 0,
    this.level = 1,
    @JsonKey(name: 'lesson_completed') this.lessonCompleted = false,
    @JsonKey(name: 'daily_goal_reached') this.dailyGoalReached = false,
  });

  factory _$AnswerResultDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnswerResultDtoImplFromJson(json);

  @override
  @JsonKey(name: 'is_correct')
  final bool isCorrect;
  @override
  @JsonKey(name: 'xp_gained')
  final int xpGained;
  @override
  @JsonKey(name: 'gems_gained')
  final int gemsGained;
  @override
  @JsonKey()
  final int hearts;
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
  @JsonKey()
  final int level;
  @override
  @JsonKey(name: 'lesson_completed')
  final bool lessonCompleted;
  @override
  @JsonKey(name: 'daily_goal_reached')
  final bool dailyGoalReached;

  @override
  String toString() {
    return 'AnswerResultDto(isCorrect: $isCorrect, xpGained: $xpGained, gemsGained: $gemsGained, hearts: $hearts, xpTotal: $xpTotal, gems: $gems, currentStreak: $currentStreak, level: $level, lessonCompleted: $lessonCompleted, dailyGoalReached: $dailyGoalReached)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnswerResultDtoImpl &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect) &&
            (identical(other.xpGained, xpGained) ||
                other.xpGained == xpGained) &&
            (identical(other.gemsGained, gemsGained) ||
                other.gemsGained == gemsGained) &&
            (identical(other.hearts, hearts) || other.hearts == hearts) &&
            (identical(other.xpTotal, xpTotal) || other.xpTotal == xpTotal) &&
            (identical(other.gems, gems) || other.gems == gems) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.lessonCompleted, lessonCompleted) ||
                other.lessonCompleted == lessonCompleted) &&
            (identical(other.dailyGoalReached, dailyGoalReached) ||
                other.dailyGoalReached == dailyGoalReached));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    isCorrect,
    xpGained,
    gemsGained,
    hearts,
    xpTotal,
    gems,
    currentStreak,
    level,
    lessonCompleted,
    dailyGoalReached,
  );

  /// Create a copy of AnswerResultDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnswerResultDtoImplCopyWith<_$AnswerResultDtoImpl> get copyWith =>
      __$$AnswerResultDtoImplCopyWithImpl<_$AnswerResultDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AnswerResultDtoImplToJson(this);
  }
}

abstract class _AnswerResultDto implements AnswerResultDto {
  const factory _AnswerResultDto({
    @JsonKey(name: 'is_correct') required final bool isCorrect,
    @JsonKey(name: 'xp_gained') final int xpGained,
    @JsonKey(name: 'gems_gained') final int gemsGained,
    final int hearts,
    @JsonKey(name: 'xp_total') final int xpTotal,
    final int gems,
    @JsonKey(name: 'current_streak') final int currentStreak,
    final int level,
    @JsonKey(name: 'lesson_completed') final bool lessonCompleted,
    @JsonKey(name: 'daily_goal_reached') final bool dailyGoalReached,
  }) = _$AnswerResultDtoImpl;

  factory _AnswerResultDto.fromJson(Map<String, dynamic> json) =
      _$AnswerResultDtoImpl.fromJson;

  @override
  @JsonKey(name: 'is_correct')
  bool get isCorrect;
  @override
  @JsonKey(name: 'xp_gained')
  int get xpGained;
  @override
  @JsonKey(name: 'gems_gained')
  int get gemsGained;
  @override
  int get hearts;
  @override
  @JsonKey(name: 'xp_total')
  int get xpTotal;
  @override
  int get gems;
  @override
  @JsonKey(name: 'current_streak')
  int get currentStreak;
  @override
  int get level;
  @override
  @JsonKey(name: 'lesson_completed')
  bool get lessonCompleted;
  @override
  @JsonKey(name: 'daily_goal_reached')
  bool get dailyGoalReached;

  /// Create a copy of AnswerResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnswerResultDtoImplCopyWith<_$AnswerResultDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProgressDto _$ProgressDtoFromJson(Map<String, dynamic> json) {
  return _ProgressDto.fromJson(json);
}

/// @nodoc
mixin _$ProgressDto {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'lesson_id')
  String get lessonId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  int get score => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// Serializes this ProgressDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProgressDtoCopyWith<ProgressDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProgressDtoCopyWith<$Res> {
  factory $ProgressDtoCopyWith(
    ProgressDto value,
    $Res Function(ProgressDto) then,
  ) = _$ProgressDtoCopyWithImpl<$Res, ProgressDto>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'lesson_id') String lessonId,
    String status,
    int score,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
  });
}

/// @nodoc
class _$ProgressDtoCopyWithImpl<$Res, $Val extends ProgressDto>
    implements $ProgressDtoCopyWith<$Res> {
  _$ProgressDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? lessonId = null,
    Object? status = null,
    Object? score = null,
    Object? completedAt = freezed,
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
            lessonId: null == lessonId
                ? _value.lessonId
                : lessonId // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            score: null == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as int,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProgressDtoImplCopyWith<$Res>
    implements $ProgressDtoCopyWith<$Res> {
  factory _$$ProgressDtoImplCopyWith(
    _$ProgressDtoImpl value,
    $Res Function(_$ProgressDtoImpl) then,
  ) = __$$ProgressDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'lesson_id') String lessonId,
    String status,
    int score,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
  });
}

/// @nodoc
class __$$ProgressDtoImplCopyWithImpl<$Res>
    extends _$ProgressDtoCopyWithImpl<$Res, _$ProgressDtoImpl>
    implements _$$ProgressDtoImplCopyWith<$Res> {
  __$$ProgressDtoImplCopyWithImpl(
    _$ProgressDtoImpl _value,
    $Res Function(_$ProgressDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? lessonId = null,
    Object? status = null,
    Object? score = null,
    Object? completedAt = freezed,
  }) {
    return _then(
      _$ProgressDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        lessonId: null == lessonId
            ? _value.lessonId
            : lessonId // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        score: null == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
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
class _$ProgressDtoImpl implements _ProgressDto {
  const _$ProgressDtoImpl({
    required this.id,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'lesson_id') required this.lessonId,
    required this.status,
    this.score = 0,
    @JsonKey(name: 'completed_at') this.completedAt,
  });

  factory _$ProgressDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProgressDtoImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'lesson_id')
  final String lessonId;
  @override
  final String status;
  @override
  @JsonKey()
  final int score;
  @override
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;

  @override
  String toString() {
    return 'ProgressDto(id: $id, userId: $userId, lessonId: $lessonId, status: $status, score: $score, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProgressDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.lessonId, lessonId) ||
                other.lessonId == lessonId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    lessonId,
    status,
    score,
    completedAt,
  );

  /// Create a copy of ProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProgressDtoImplCopyWith<_$ProgressDtoImpl> get copyWith =>
      __$$ProgressDtoImplCopyWithImpl<_$ProgressDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProgressDtoImplToJson(this);
  }
}

abstract class _ProgressDto implements ProgressDto {
  const factory _ProgressDto({
    required final String id,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'lesson_id') required final String lessonId,
    required final String status,
    final int score,
    @JsonKey(name: 'completed_at') final DateTime? completedAt,
  }) = _$ProgressDtoImpl;

  factory _ProgressDto.fromJson(Map<String, dynamic> json) =
      _$ProgressDtoImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'lesson_id')
  String get lessonId;
  @override
  String get status;
  @override
  int get score;
  @override
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt;

  /// Create a copy of ProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProgressDtoImplCopyWith<_$ProgressDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HeartsStatusDto _$HeartsStatusDtoFromJson(Map<String, dynamic> json) {
  return _HeartsStatusDto.fromJson(json);
}

/// @nodoc
mixin _$HeartsStatusDto {
  int get hearts => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_hearts')
  int get maxHearts => throw _privateConstructorUsedError;
  @JsonKey(name: 'heart_refill_at')
  DateTime? get heartRefillAt => throw _privateConstructorUsedError;
  int get gems => throw _privateConstructorUsedError;

  /// Serializes this HeartsStatusDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HeartsStatusDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HeartsStatusDtoCopyWith<HeartsStatusDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HeartsStatusDtoCopyWith<$Res> {
  factory $HeartsStatusDtoCopyWith(
    HeartsStatusDto value,
    $Res Function(HeartsStatusDto) then,
  ) = _$HeartsStatusDtoCopyWithImpl<$Res, HeartsStatusDto>;
  @useResult
  $Res call({
    int hearts,
    @JsonKey(name: 'max_hearts') int maxHearts,
    @JsonKey(name: 'heart_refill_at') DateTime? heartRefillAt,
    int gems,
  });
}

/// @nodoc
class _$HeartsStatusDtoCopyWithImpl<$Res, $Val extends HeartsStatusDto>
    implements $HeartsStatusDtoCopyWith<$Res> {
  _$HeartsStatusDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HeartsStatusDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hearts = null,
    Object? maxHearts = null,
    Object? heartRefillAt = freezed,
    Object? gems = null,
  }) {
    return _then(
      _value.copyWith(
            hearts: null == hearts
                ? _value.hearts
                : hearts // ignore: cast_nullable_to_non_nullable
                      as int,
            maxHearts: null == maxHearts
                ? _value.maxHearts
                : maxHearts // ignore: cast_nullable_to_non_nullable
                      as int,
            heartRefillAt: freezed == heartRefillAt
                ? _value.heartRefillAt
                : heartRefillAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            gems: null == gems
                ? _value.gems
                : gems // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HeartsStatusDtoImplCopyWith<$Res>
    implements $HeartsStatusDtoCopyWith<$Res> {
  factory _$$HeartsStatusDtoImplCopyWith(
    _$HeartsStatusDtoImpl value,
    $Res Function(_$HeartsStatusDtoImpl) then,
  ) = __$$HeartsStatusDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int hearts,
    @JsonKey(name: 'max_hearts') int maxHearts,
    @JsonKey(name: 'heart_refill_at') DateTime? heartRefillAt,
    int gems,
  });
}

/// @nodoc
class __$$HeartsStatusDtoImplCopyWithImpl<$Res>
    extends _$HeartsStatusDtoCopyWithImpl<$Res, _$HeartsStatusDtoImpl>
    implements _$$HeartsStatusDtoImplCopyWith<$Res> {
  __$$HeartsStatusDtoImplCopyWithImpl(
    _$HeartsStatusDtoImpl _value,
    $Res Function(_$HeartsStatusDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HeartsStatusDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hearts = null,
    Object? maxHearts = null,
    Object? heartRefillAt = freezed,
    Object? gems = null,
  }) {
    return _then(
      _$HeartsStatusDtoImpl(
        hearts: null == hearts
            ? _value.hearts
            : hearts // ignore: cast_nullable_to_non_nullable
                  as int,
        maxHearts: null == maxHearts
            ? _value.maxHearts
            : maxHearts // ignore: cast_nullable_to_non_nullable
                  as int,
        heartRefillAt: freezed == heartRefillAt
            ? _value.heartRefillAt
            : heartRefillAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        gems: null == gems
            ? _value.gems
            : gems // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HeartsStatusDtoImpl implements _HeartsStatusDto {
  const _$HeartsStatusDtoImpl({
    this.hearts = 0,
    @JsonKey(name: 'max_hearts') this.maxHearts = 5,
    @JsonKey(name: 'heart_refill_at') this.heartRefillAt,
    this.gems = 0,
  });

  factory _$HeartsStatusDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$HeartsStatusDtoImplFromJson(json);

  @override
  @JsonKey()
  final int hearts;
  @override
  @JsonKey(name: 'max_hearts')
  final int maxHearts;
  @override
  @JsonKey(name: 'heart_refill_at')
  final DateTime? heartRefillAt;
  @override
  @JsonKey()
  final int gems;

  @override
  String toString() {
    return 'HeartsStatusDto(hearts: $hearts, maxHearts: $maxHearts, heartRefillAt: $heartRefillAt, gems: $gems)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HeartsStatusDtoImpl &&
            (identical(other.hearts, hearts) || other.hearts == hearts) &&
            (identical(other.maxHearts, maxHearts) ||
                other.maxHearts == maxHearts) &&
            (identical(other.heartRefillAt, heartRefillAt) ||
                other.heartRefillAt == heartRefillAt) &&
            (identical(other.gems, gems) || other.gems == gems));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, hearts, maxHearts, heartRefillAt, gems);

  /// Create a copy of HeartsStatusDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HeartsStatusDtoImplCopyWith<_$HeartsStatusDtoImpl> get copyWith =>
      __$$HeartsStatusDtoImplCopyWithImpl<_$HeartsStatusDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$HeartsStatusDtoImplToJson(this);
  }
}

abstract class _HeartsStatusDto implements HeartsStatusDto {
  const factory _HeartsStatusDto({
    final int hearts,
    @JsonKey(name: 'max_hearts') final int maxHearts,
    @JsonKey(name: 'heart_refill_at') final DateTime? heartRefillAt,
    final int gems,
  }) = _$HeartsStatusDtoImpl;

  factory _HeartsStatusDto.fromJson(Map<String, dynamic> json) =
      _$HeartsStatusDtoImpl.fromJson;

  @override
  int get hearts;
  @override
  @JsonKey(name: 'max_hearts')
  int get maxHearts;
  @override
  @JsonKey(name: 'heart_refill_at')
  DateTime? get heartRefillAt;
  @override
  int get gems;

  /// Create a copy of HeartsStatusDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HeartsStatusDtoImplCopyWith<_$HeartsStatusDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
