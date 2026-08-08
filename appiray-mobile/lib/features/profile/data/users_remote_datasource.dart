import 'package:dio/dio.dart';

import 'package:appiray/core/network/api_endpoints.dart';
import 'package:appiray/core/network/api_exception.dart';
import 'package:appiray/features/profile/data/models/user_models.dart';

/// Accès réseau brut pour l'utilisateur courant.
class UsersRemoteDataSource {
  UsersRemoteDataSource(this._dio);
  final Dio _dio;

  Future<UserDto> getMe() async {
    try {
      final resp = await _dio.get<Map<String, dynamic>>(ApiEndpoints.usersMe);
      return UserDto.fromJson(resp.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<UserDto> updateUsername(String username) async {
    try {
      final resp = await _dio.patch<Map<String, dynamic>>(
        ApiEndpoints.usersMe,
        data: {'username': username},
      );
      return UserDto.fromJson(resp.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
