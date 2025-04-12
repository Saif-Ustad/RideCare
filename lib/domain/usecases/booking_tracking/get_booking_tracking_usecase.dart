import '../../entities/booking_tracking_entity.dart';
import '../../repositories/booking_tracking_repository.dart';

class GetBookingTrackingUseCase {
  final BookingTrackingRepository repository;

  GetBookingTrackingUseCase({required this.repository});

  Future<BookingTrackingEntity> call(String bookingId) {
    return repository.getTrackingForBooking(bookingId);
  }
}

