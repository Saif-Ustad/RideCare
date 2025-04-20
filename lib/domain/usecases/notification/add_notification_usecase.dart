import '../../entities/notification_entity.dart';
import '../../repositories/notification_repository.dart';

class AddNotificationUseCase {
  final NotificationRepository repository;

  AddNotificationUseCase({required this.repository});

  Future<void> call(String userId, NotificationEntity notification) {
    return repository.addNotification(userId, notification);
  }
}
