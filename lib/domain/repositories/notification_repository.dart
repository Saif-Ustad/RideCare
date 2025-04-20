import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<void> addNotification(String userId, NotificationEntity notification);

  Stream<List<NotificationEntity>> getNotifications(String userId);
}
