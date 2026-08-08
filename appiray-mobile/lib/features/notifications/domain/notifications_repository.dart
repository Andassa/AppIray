import 'package:appiray/core/utils/result.dart';
import 'package:appiray/features/notifications/domain/notification_entities.dart';

/// Contrat du repository de notifications (domaine).
abstract interface class NotificationsRepository {
  Future<Result<List<NotificationItem>>> list({bool unreadOnly});
  Future<Result<void>> markRead(String id);
  Future<Result<void>> markAllRead();
  Future<Result<void>> registerDeviceToken({
    required String token,
    required String platform,
  });
  Future<Result<void>> removeDeviceToken({
    required String token,
    required String platform,
  });
}
