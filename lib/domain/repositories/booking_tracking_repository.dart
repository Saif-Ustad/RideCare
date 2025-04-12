import '../entities/booking_tracking_entity.dart';

abstract class BookingTrackingRepository {
  Future<BookingTrackingEntity> getTrackingForBooking(String bookingId);

  Future<String> createTrackingForBooking(
    String bookingId,
    List<BookingTrackingUpdateEntity> updates,
  );
}
