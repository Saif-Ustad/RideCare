import 'package:ridecare/domain/repositories/booking_repository.dart';

import '../../entities/booking_entity.dart';

class PrepareBookingSummaryUseCase {
  final BookingRepository repository;

  PrepareBookingSummaryUseCase({required this.repository});

  Future<BookingEntity> call(BookingEntity booking) {
    return repository.prepareBillSummary(booking);
  }
}
