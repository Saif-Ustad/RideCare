import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/notification_entity.dart';
import '../../../../domain/usecases/notification/add_notification_usecase.dart';
import '../../../../domain/usecases/notification/get_notifications_usecase.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final AddNotificationUseCase addNotificationUseCase;
  final GetNotificationsUseCase getNotificationsUseCase;

  StreamSubscription<List<NotificationEntity>>? _notificationSubscription;

  NotificationBloc({
    required this.addNotificationUseCase,
    required this.getNotificationsUseCase,
  }) : super(NotificationInitial()) {
    on<AddNotificationEvent>(_handleAddNotification);
    on<StartListeningNotificationsEvent>(_handleGetNotifications);
    on<NotificationsUpdatedEvent>(_handleNotificationsUpdated);
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

  @override
  Future<void> close() {
    _notificationSubscription?.cancel();
    return super.close();
  }
}
