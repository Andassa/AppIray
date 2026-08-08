import 'package:dio/dio.dart';

import 'package:appiray/core/network/api_endpoints.dart';
import 'package:appiray/core/network/api_exception.dart';
import 'package:appiray/features/social/data/models/social_models.dart';

/// Accès réseau brut pour le social.
class SocialRemoteDataSource {
  SocialRemoteDataSource(this._dio);
  final Dio _dio;

  Future<List<UserSearchResultDto>> searchUsers(String query) async {
    try {
      final resp = await _dio.get<List<dynamic>>(
        ApiEndpoints.userSearch,
        queryParameters: {'query': query},
      );
      return (resp.data ?? [])
          .map((e) => UserSearchResultDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<List<FriendshipDto>> listFriends() async {
    try {
      final resp = await _dio.get<List<dynamic>>(ApiEndpoints.friends);
      return (resp.data ?? [])
          .map((e) => FriendshipDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<FriendshipDto> requestFriend(String friendId) async {
    try {
      final resp = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.friendRequest,
        data: {'friend_id': friendId},
      );
      return FriendshipDto.fromJson(resp.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<FriendshipDto> acceptFriend(String friendshipId) async {
    try {
      final resp = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.friendAccept(friendshipId),
      );
      return FriendshipDto.fromJson(resp.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<List<FriendLeaderboardEntryDto>> friendsLeaderboard() async {
    try {
      final resp =
          await _dio.get<List<dynamic>>(ApiEndpoints.friendsLeaderboard);
      return (resp.data ?? [])
          .map((e) =>
              FriendLeaderboardEntryDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
