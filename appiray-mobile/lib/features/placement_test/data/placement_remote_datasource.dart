import 'package:dio/dio.dart';

import 'package:appiray/core/network/api_endpoints.dart';
import 'package:appiray/core/network/api_exception.dart';
import 'package:appiray/features/lesson_player/data/models/lesson_models.dart';
import 'package:appiray/features/placement_test/data/models/placement_models.dart';

/// Accès réseau brut pour le test de positionnement.
class PlacementRemoteDataSource {
  PlacementRemoteDataSource(this._dio);
  final Dio _dio;

  Future<List<ExerciseDto>> getExercises(String courseId) async {
    try {
      final resp = await _dio.get<List<dynamic>>(
        ApiEndpoints.placementTest(courseId),
      );
      return (resp.data ?? [])
          .map((e) => ExerciseDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<PlacementResultDto> submit({
    required String courseId,
    required Map<String, String> answers,
  }) async {
    try {
      final resp = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.placementTestSubmit(courseId),
        data: {
          'answers': [
            for (final entry in answers.entries)
              {'exercise_id': entry.key, 'answer': entry.value},
          ],
        },
      );
      return PlacementResultDto.fromJson(resp.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
