import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:appiray/core/utils/result.dart';
import 'package:appiray/features/notifications/data/notifications_repository_impl.dart';
import 'package:appiray/features/notifications/domain/notification_entities.dart';

part 'notifications_controller.g.dart';

@riverpod
class NotificationsController extends _$NotificationsController {
  @override
  Future<List<NotificationItem>> build() async {
    final result = await ref.read(notificationsRepositoryProvider).list();
    return switch (result) {
      Success<List<NotificationItem>>(:final value) => value,
      FailureResult<List<NotificationItem>>(:final failure) =>
        throw Exception(failure.message),
    };
  }

  Future<void> markRead(String id) async {
    final result =
        await ref.read(notificationsRepositoryProvider).markRead(id);
    if (result.isSuccess) ref.invalidateSelf();
  }

  Future<void> markAllRead() async {
    final result =
        await ref.read(notificationsRepositoryProvider).markAllRead();
    if (result.isSuccess) ref.invalidateSelf();
  }
}
