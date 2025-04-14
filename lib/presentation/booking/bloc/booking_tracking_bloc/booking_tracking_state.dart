import '../../../../domain/entities/booking_tracking_entity.dart';

abstract class BookingTrackingState {}

class BookingTrackingInitial extends BookingTrackingState {}

class BookingTrackingLoading extends BookingTrackingState {}

class BookingTrackingLoaded extends BookingTrackingState {
  final BookingTrackingEntity tracking;

  BookingTrackingLoaded(this.tracking);
}

class BookingTrackingError extends BookingTrackingState {
  final String message;

  BookingTrackingError(this.message);
}
