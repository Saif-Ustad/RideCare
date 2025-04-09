import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ridecare/data/models/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<String> createBooking(BookingModel booking);
  Future<void> updateBooking(String bookingId, Map<String, dynamic> data);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final FirebaseFirestore firestore;

  BookingRemoteDataSourceImpl({required this.firestore});

  @override
  Future<String> createBooking(BookingModel booking) async {
    final docRef = await firestore.collection('bookings').add(booking.toJson());
    return docRef.id;
  }

  @override
  Future<void> updateBooking(String bookingId, Map<String, dynamic> data) async {
    await firestore.collection('bookings').doc(bookingId).update(data);
  }
}
