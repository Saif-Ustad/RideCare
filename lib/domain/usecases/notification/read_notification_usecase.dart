import '../../repositories/notification_repository.dart';

class ReadNotificationsUseCase {
  final NotificationRepository repository;

  ReadNotificationsUseCase({required this.repository});

  Future<void> call(String userId, String notificationId) {
    return repository.readNotification(userId, notificationId);
  }
}
