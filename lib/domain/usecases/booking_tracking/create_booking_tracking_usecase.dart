import '../../entities/booking_tracking_entity.dart';
import '../../repositories/booking_tracking_repository.dart';

class CreateBookingTrackingUseCase {
  final BookingTrackingRepository repository;

  CreateBookingTrackingUseCase({required this.repository});

  Future<String> call(
    String bookingId,
    List<BookingTrackingUpdateEntity> updates,
  ) async {
    return await repository.createTrackingForBooking(bookingId, updates);
  }
}
