
class NotificationEntity {
  final String? id;
  final String title;
  final String body;
  final DateTime? timestamp;
  final bool? isRead;
  final String type;

  NotificationEntity({
    this.id,
    required this.title,
    required this.body,
    this.timestamp,
    this.isRead,
    required this.type,
  });
}
