/// Entités domaine des notifications.
class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.type,
    required this.payload,
    required this.read,
    this.createdAt,
  });

  final String id;
  final String type;
  final Map<String, dynamic> payload;
  final bool read;
  final DateTime? createdAt;

  /// Titre lisible dérivé du payload (best-effort).
  String get title =>
      (payload['title'] ?? payload['message'] ?? type).toString();
}
