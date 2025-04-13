import 'package:ridecare/domain/entities/booking_entity.dart';
import 'package:ridecare/domain/repositories/booking_repository.dart';

class GetAllBookingUseCase {
  final BookingRepository repository;

  GetAllBookingUseCase({required this.repository});

  Future<List<BookingEntity>> call(String userId) {
    return repository.getAllBookings(userId);
  }
}
