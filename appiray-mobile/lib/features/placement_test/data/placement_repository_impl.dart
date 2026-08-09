import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:appiray/core/network/api_exception.dart';
import 'package:appiray/core/providers/core_providers.dart';
import 'package:appiray/core/utils/result.dart';
import 'package:appiray/features/lesson_player/data/models/lesson_models.dart';
import 'package:appiray/features/lesson_player/domain/lesson_entities.dart';
import 'package:appiray/features/placement_test/data/placement_remote_datasource.dart';
import 'package:appiray/features/placement_test/domain/placement_entities.dart';
import 'package:appiray/features/placement_test/domain/placement_repository.dart';

part 'placement_repository_impl.g.dart';

@riverpod
PlacementRemoteDataSource placementRemoteDataSource(
  PlacementRemoteDataSourceRef ref,
) =>
    PlacementRemoteDataSource(ref.watch(dioClientProvider));

@riverpod
PlacementRepository placementRepository(PlacementRepositoryRef ref) =>
    PlacementRepositoryImpl(ref.watch(placementRemoteDataSourceProvider));

class PlacementRepositoryImpl implements PlacementRepository {
  PlacementRepositoryImpl(this._remote);
  final PlacementRemoteDataSource _remote;

  Exercise _toExercise(ExerciseDto d) => Exercise(
        id: d.id,
        lessonId: d.lessonId,
        type: ExerciseType.fromApi(d.type),
        content: d.content,
        audioAssetId: d.audioAssetId,
      );

  @override
  Future<Result<List<Exercise>>> getExercises(String courseId) =>
      _guard(() async {
        final list = await _remote.getExercises(courseId);
        final sorted = list.toList()..sort((a, b) => a.order.compareTo(b.order));
        return sorted.map(_toExercise).toList();
      });

  @override
  Future<Result<PlacementResult>> submit({
    required String courseId,
    required Map<String, String> answers,
  }) =>
      _guard(() async {
        final dto = await _remote.submit(
          courseId: courseId,
          answers: answers,
        );
        return PlacementResult(
          correctCount: dto.correctCount,
          unitsUnlocked: dto.unitsUnlocked,
        );
      });

  Future<Result<T>> _guard<T>(Future<T> Function() body) async {
    try {
      return Result.success(await body());
    } on ApiException catch (e) {
      return Result.failure(Failure.fromApiException(e));
    } catch (e) {
      return Result.failure(Failure.unexpected(e));
    }
  }
}
