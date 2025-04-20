import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_datasource.dart';
import '../models/notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addNotification(String userId, NotificationEntity notification) {
    return remoteDataSource.addNotification(
      userId,
      NotificationModel.fromEntity(notification),
    );
  }

  @override
  Stream<List<NotificationEntity>> getNotifications(String userId) {
    return remoteDataSource.getNotifications(userId);
  }
}
