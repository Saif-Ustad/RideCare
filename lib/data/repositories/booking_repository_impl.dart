import 'package:ridecare/data/datasources/booking_remote_datasource.dart';
import 'package:ridecare/data/models/booking_model.dart';

import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> createBooking(BookingEntity booking) {
    final bookingModel = BookingModel.fromEntity(booking);
    return remoteDataSource.createBooking(bookingModel);
  }

  @override
  Future<void> updateBooking(String bookingId, Map<String, dynamic> data) {
    return remoteDataSource.updateBooking(bookingId, data);
  }
}
