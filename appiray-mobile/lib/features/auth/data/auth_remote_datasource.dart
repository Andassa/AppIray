import 'package:dio/dio.dart';

import 'package:appiray/core/network/api_endpoints.dart';
import 'package:appiray/core/network/api_exception.dart';
import 'package:appiray/features/auth/data/models/auth_models.dart';

/// Accès réseau brut pour l'auth. Retourne des DTOs, lève [ApiException].
class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dio);
  final Dio _dio;

  Future<AuthTokensDto> login(LoginRequest request) async {
    try {
      final resp = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: request.toJson(),
      );
      return AuthTokensDto.fromJson(resp.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<AuthTokensDto> register(RegisterRequest request) async {
    try {
      final resp = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.register,
        data: request.toJson(),
      );
      return AuthTokensDto.fromJson(resp.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> forgotPassword(ForgotPasswordRequest request) async {
    try {
      await _dio.post<dynamic>(
        ApiEndpoints.forgotPassword,
        data: request.toJson(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> resetPassword(ResetPasswordRequest request) async {
    try {
      await _dio.post<dynamic>(
        ApiEndpoints.resetPassword,
        data: request.toJson(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> requestEmailVerification() async {
    try {
      await _dio.post<dynamic>(ApiEndpoints.verifyEmailRequest);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> logout(String refreshToken) async {
    try {
      await _dio.post<dynamic>(
        ApiEndpoints.logout,
        data: {'refresh_token': refreshToken},
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
