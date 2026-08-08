import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:appiray/core/network/api_exception.dart';
import 'package:appiray/core/providers/core_providers.dart';
import 'package:appiray/core/utils/result.dart';
import 'package:appiray/features/notifications/data/models/notification_models.dart';
import 'package:appiray/features/notifications/data/notifications_remote_datasource.dart';
import 'package:appiray/features/notifications/domain/notification_entities.dart';
import 'package:appiray/features/notifications/domain/notifications_repository.dart';

part 'notifications_repository_impl.g.dart';

@riverpod
NotificationsRemoteDataSource notificationsRemoteDataSource(
        NotificationsRemoteDataSourceRef ref) =>
    NotificationsRemoteDataSource(ref.watch(dioClientProvider));

@riverpod
NotificationsRepository notificationsRepository(
        NotificationsRepositoryRef ref) =>
    NotificationsRepositoryImpl(
        ref.watch(notificationsRemoteDataSourceProvider));

class NotificationsRepositoryImpl implements NotificationsRepository {
  NotificationsRepositoryImpl(this._remote);
  final NotificationsRemoteDataSource _remote;

  NotificationItem _toEntity(NotificationDto d) => NotificationItem(
        id: d.id,
        type: d.type,
        payload: d.payload,
        read: d.readAt != null,
        createdAt: d.createdAt,
      );

  @override
  Future<Result<List<NotificationItem>>> list({bool unreadOnly = false}) =>
      _guard(() async {
        final list = await _remote.list(unreadOnly: unreadOnly);
        return list.map(_toEntity).toList();
      });

  @override
  Future<Result<void>> markRead(String id) =>
      _guard(() => _remote.markRead(id));

  @override
  Future<Result<void>> markAllRead() => _guard(() => _remote.markAllRead());

  @override
  Future<Result<void>> registerDeviceToken({
    required String token,
    required String platform,
  }) =>
      _guard(() =>
          _remote.registerDeviceToken(token: token, platform: platform));

  @override
  Future<Result<void>> removeDeviceToken({
    required String token,
    required String platform,
  }) =>
      _guard(() => _remote.removeDeviceToken(token: token, platform: platform));

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
