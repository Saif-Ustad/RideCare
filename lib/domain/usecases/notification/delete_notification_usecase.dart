import '../../repositories/notification_repository.dart';

class DeleteNotificationUseCase {
  final NotificationRepository repository;

  DeleteNotificationUseCase({required this.repository});

  Future<void> call(String userId, String notificationId) {
    return repository.deleteNotification(userId, notificationId);
  }
}
