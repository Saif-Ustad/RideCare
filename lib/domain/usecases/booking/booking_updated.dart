import 'package:ridecare/domain/repositories/booking_repository.dart';

class BookingUpdatedUseCase {
  final BookingRepository repository;

  BookingUpdatedUseCase({required this.repository});

  Future<void> call(String bookingId, Map<String, dynamic> data) {
    return repository.updateBooking(bookingId, data);
  }
}
