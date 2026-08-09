import 'package:dio/dio.dart';

import 'package:appiray/core/network/api_endpoints.dart';
import 'package:appiray/core/network/api_exception.dart';
import 'package:appiray/features/lesson_player/data/models/lesson_models.dart';

/// Accès réseau brut pour la progression et le contenu des leçons.
class ProgressRemoteDataSource {
  ProgressRemoteDataSource(this._dio);
  final Dio _dio;

  Future<LessonDetailDto> getLesson(String lessonId) async {
    try {
      final resp = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.lesson(lessonId),
      );
      return LessonDetailDto.fromJson(resp.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<AnswerResultDto> submitAnswer({
    required String exerciseId,
    required String answer,
    required bool practice,
  }) async {
    try {
      final resp = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.answer,
        data: {
          'exercise_id': exerciseId,
          'answer': answer,
          'practice': practice,
        },
      );
      return AnswerResultDto.fromJson(resp.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<List<ProgressDto>> listProgress() async {
    try {
      final resp = await _dio.get<List<dynamic>>(ApiEndpoints.progressMe);
      return (resp.data ?? [])
          .map((e) => ProgressDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<HeartsStatusDto> getHearts() async {
    try {
      final resp =
          await _dio.get<Map<String, dynamic>>(ApiEndpoints.hearts);
      return HeartsStatusDto.fromJson(resp.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<HeartsStatusDto> refillHeartsWithGems() async {
    try {
      final resp = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.heartsRefillWithGems,
      );
      return HeartsStatusDto.fromJson(resp.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> buyStreakFreeze() async {
    try {
      await _dio.post<dynamic>(ApiEndpoints.streakFreeze);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<int> updateDailyGoal(int dailyXpGoal) async {
    try {
      final resp = await _dio.patch<Map<String, dynamic>>(
        ApiEndpoints.dailyGoal,
        data: {'daily_xp_goal': dailyXpGoal},
      );
      return (resp.data?['daily_xp_goal'] as num?)?.toInt() ?? dailyXpGoal;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<List<ExerciseDto>> getPracticeExercises() async {
    try {
      final resp = await _dio.get<List<dynamic>>(ApiEndpoints.practice);
      return (resp.data ?? [])
          .map((e) => ExerciseDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
