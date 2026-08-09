import 'package:freezed_annotation/freezed_annotation.dart';

part 'placement_models.freezed.dart';
part 'placement_models.g.dart';

/// Réponse de `POST /courses/{id}/placement-test/submit` (PlacementResult).
@freezed
class PlacementResultDto with _$PlacementResultDto {
  const factory PlacementResultDto({
    @JsonKey(name: 'correct_count') @Default(0) int correctCount,
    @JsonKey(name: 'units_unlocked') @Default(0) int unitsUnlocked,
  }) = _PlacementResultDto;

  factory PlacementResultDto.fromJson(Map<String, dynamic> json) =>
      _$PlacementResultDtoFromJson(json);
}
