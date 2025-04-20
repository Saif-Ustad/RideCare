import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<void> addNotification(String userId, NotificationEntity notification);

  Stream<List<NotificationEntity>> getNotifications(String userId);

  Future<void> deleteNotification(String userId, String notificationId);

  Future<void> readNotification(String userId, String notificationId);
}
