// booking_tracking_event.dart
abstract class BookingTrackingEvent {}

class GetBookingTrackingInfo extends BookingTrackingEvent {
  final String bookingId;

  GetBookingTrackingInfo(this.bookingId);
}
