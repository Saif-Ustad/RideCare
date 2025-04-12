import 'package:ridecare/data/models/booking_tracking_model.dart';

import '../../domain/entities/booking_tracking_entity.dart';
import '../../domain/repositories/booking_tracking_repository.dart';
import '../datasources/booking_tracking_remote_datasource.dart';

class BookingTrackingRepositoryImpl implements BookingTrackingRepository {
  final BookingTrackingRemoteDataSource remoteDataSource;

  BookingTrackingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<BookingTrackingEntity> getTrackingForBooking(String bookingId) async {
    return await remoteDataSource.getTrackingForBooking(bookingId);
  }

  @override
  Future<String> createTrackingForBooking(
    String bookingId,
    List<BookingTrackingUpdateEntity> updates,
  ) async {
    return await remoteDataSource.createTrackingForBooking(
      bookingId,
      updates.map((e) => BookingTrackingUpdateModel.fromEntity(e)).toList(),
    );
  }
}
