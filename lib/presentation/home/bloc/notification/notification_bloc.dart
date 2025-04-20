import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridecare/domain/usecases/notification/delete_notification_usecase.dart';
import 'package:ridecare/domain/usecases/notification/read_notification_usecase.dart';
import '../../../../domain/entities/notification_entity.dart';
import '../../../../domain/usecases/notification/add_notification_usecase.dart';
import '../../../../domain/usecases/notification/get_notifications_usecase.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final AddNotificationUseCase addNotificationUseCase;
  final GetNotificationsUseCase getNotificationsUseCase;
  final DeleteNotificationUseCase deleteNotificationUseCase;
  final ReadNotificationsUseCase readNotificationsUseCase;

  StreamSubscription<List<NotificationEntity>>? _notificationSubscription;

  NotificationBloc({
    required this.addNotificationUseCase,
    required this.getNotificationsUseCase,
    required this.deleteNotificationUseCase,
    required this.readNotificationsUseCase,
  }) : super(NotificationInitial()) {
    on<AddNotificationEvent>(_handleAddNotification);
    on<StartListeningNotificationsEvent>(_handleGetNotifications);
    on<NotificationsUpdatedEvent>(_handleNotificationsUpdated);
    on<DeleteNotificationEvent>(_handleDeleteNotificationEvent);
    on<ReadNotificationEvent>(_handleReadNotificationEvent);
  }

  Future<void> _handleAddNotification(
    AddNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await addNotificationUseCase(event.userId, event.notification);
    } catch (e) {
      emit(NotificationError(message: 'Failed to add notification: $e'));
    }
  }

  Future<void> _handleGetNotifications(
    StartListeningNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());

    await _notificationSubscription?.cancel();

    final result = getNotificationsUseCase(
      event.userId,
    ); // Ensure this is awaited
    _notificationSubscription = result.listen((notificationEntity) {
      add(NotificationsUpdatedEvent(notifications: notificationEntity));
    });
  }

  Future<void> _handleNotificationsUpdated(
    NotificationsUpdatedEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoaded(notifications: event.notifications));
  }

  Future<void> _handleDeleteNotificationEvent(
    DeleteNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await deleteNotificationUseCase(event.userId, event.notificationId);
    } catch (e) {
      emit(NotificationError(message: 'Failed to delete notification: $e'));
    }
  }

  Future<void> _handleReadNotificationEvent(
    ReadNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await readNotificationsUseCase(event.userId, event.notificationId);
    } catch (e) {
      emit(
        NotificationError(message: 'Failed to mark notification as read: $e'),
      );
    }
  }

  @override
  Future<void> close() {
    _notificationSubscription?.cancel();
    return super.close();
  }
}
