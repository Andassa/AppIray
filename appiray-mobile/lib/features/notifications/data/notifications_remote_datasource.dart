import 'package:dio/dio.dart';

import 'package:appiray/core/network/api_endpoints.dart';
import 'package:appiray/core/network/api_exception.dart';
import 'package:appiray/features/notifications/data/models/notification_models.dart';

/// Accès réseau brut pour les notifications.
class NotificationsRemoteDataSource {
  NotificationsRemoteDataSource(this._dio);
  final Dio _dio;

  Future<List<NotificationDto>> list({bool unreadOnly = false}) async {
    try {
      final resp = await _dio.get<List<dynamic>>(
        ApiEndpoints.notifications,
        queryParameters: {'unread_only': unreadOnly},
      );
      return (resp.data ?? [])
          .map((e) => NotificationDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> markRead(String id) async {
    try {
      await _dio.post<dynamic>(ApiEndpoints.notificationRead(id));
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> markAllRead() async {
    try {
      await _dio.post<dynamic>(ApiEndpoints.notificationsReadAll);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> registerDeviceToken({
    required String token,
    required String platform,
  }) async {
    try {
      await _dio.post<dynamic>(
        ApiEndpoints.deviceToken,
        data: {'token': token, 'platform': platform},
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> removeDeviceToken({
    required String token,
    required String platform,
  }) async {
    try {
      await _dio.delete<dynamic>(
        ApiEndpoints.deviceToken,
        data: {'token': token, 'platform': platform},
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
