import 'package:equatable/equatable.dart';

import '../../../../domain/entities/notification_entity.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class AddNotificationEvent extends NotificationEvent {
  final String userId;
  final NotificationEntity notification;

  const AddNotificationEvent({
    required this.userId,
    required this.notification,
  });

  @override
  List<Object?> get props => [userId, notification];
}

class StartListeningNotificationsEvent extends NotificationEvent {
  final String userId;

  const StartListeningNotificationsEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class NotificationsUpdatedEvent extends NotificationEvent {
  final List<NotificationEntity> notifications;

  const NotificationsUpdatedEvent({required this.notifications});

  @override
  List<Object?> get props => [notifications];
}

class DeleteNotificationEvent extends NotificationEvent {
  final String userId;
  final String notificationId;

  const DeleteNotificationEvent({
    required this.userId,
    required this.notificationId,
  });

  @override
  List<Object?> get props => [userId, notificationId];
}

class ReadNotificationEvent extends NotificationEvent {
  final String userId;
  final String notificationId;

  const ReadNotificationEvent({
    required this.userId,
    required this.notificationId,
  });
}
