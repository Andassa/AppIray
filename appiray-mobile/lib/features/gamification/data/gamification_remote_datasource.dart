import 'package:dio/dio.dart';

import 'package:appiray/core/network/api_endpoints.dart';
import 'package:appiray/core/network/api_exception.dart';
import 'package:appiray/features/gamification/data/models/gamification_models.dart';

/// Accès réseau brut pour la gamification.
class GamificationRemoteDataSource {
  GamificationRemoteDataSource(this._dio);
  final Dio _dio;

  Future<LeagueDto> myLeague() async {
    try {
      final resp = await _dio.get<Map<String, dynamic>>(ApiEndpoints.leagueMe);
      return LeagueDto.fromJson(resp.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<List<LeaderboardEntryDto>> leaderboard({int limit = 50}) async {
    try {
      final resp = await _dio.get<List<dynamic>>(
        ApiEndpoints.leaderboard,
        queryParameters: {'limit': limit},
      );
      return (resp.data ?? [])
          .map((e) => LeaderboardEntryDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<List<UserBadgeDto>> myBadges() async {
    try {
      final resp = await _dio.get<List<dynamic>>(ApiEndpoints.badgesMe);
      return (resp.data ?? [])
          .map((e) => UserBadgeDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<List<UserDailyQuestDto>> myQuests() async {
    try {
      final resp = await _dio.get<List<dynamic>>(ApiEndpoints.questsMe);
      return (resp.data ?? [])
          .map((e) => UserDailyQuestDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
