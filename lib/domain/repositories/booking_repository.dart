import '../entities/booking_entity.dart';

abstract class BookingRepository {
  Future<String> createBooking(BookingEntity booking);
  Future<void> updateBooking(String bookingId, Map<String, dynamic> data);
  Future<BookingEntity> prepareBillSummary(BookingEntity booking);
}
