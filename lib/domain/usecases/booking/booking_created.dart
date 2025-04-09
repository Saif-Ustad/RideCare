import 'package:ridecare/domain/repositories/booking_repository.dart';

import '../../entities/booking_entity.dart';

class BookingCreatedUseCase {
  final BookingRepository repository;

  BookingCreatedUseCase({required this.repository});

  Future<String> call(BookingEntity booking) {
    return repository.createBooking(booking);
  }
}
