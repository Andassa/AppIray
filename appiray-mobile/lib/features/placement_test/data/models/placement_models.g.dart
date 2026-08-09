// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'placement_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlacementResultDtoImpl _$$PlacementResultDtoImplFromJson(
  Map<String, dynamic> json,
) => _$PlacementResultDtoImpl(
  correctCount: (json['correct_count'] as num?)?.toInt() ?? 0,
  unitsUnlocked: (json['units_unlocked'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$PlacementResultDtoImplToJson(
  _$PlacementResultDtoImpl instance,
) => <String, dynamic>{
  'correct_count': instance.correctCount,
  'units_unlocked': instance.unitsUnlocked,
};
