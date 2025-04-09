
import '../../../domain/entities/booking_entity.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingUpdated extends BookingState {
  final BookingEntity booking;
  BookingUpdated({required this.booking});
}

class BookingLoading extends BookingState {}

class BookingSubmitted extends BookingState {
  final String bookingId;
  BookingSubmitted(this.bookingId);
}

class BookingError extends BookingState {
  final String message;
  BookingError(this.message);
}
