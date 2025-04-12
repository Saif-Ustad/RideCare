import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking_tracking_model.dart';

abstract class BookingTrackingRemoteDataSource {
  Future<BookingTrackingModel> getTrackingForBooking(String bookingId);

  Future<String> createTrackingForBooking(
    String bookingId,
    List<BookingTrackingUpdateModel> updates,
  );
}

class BookingTrackingRemoteDataSourceImpl
    implements BookingTrackingRemoteDataSource {
  final FirebaseFirestore firestore;

  BookingTrackingRemoteDataSourceImpl({required this.firestore});

  @override
  Future<BookingTrackingModel> getTrackingForBooking(String bookingId) async {
    final doc =
        await firestore.collection('booking_tracking').doc(bookingId).get();

    if (!doc.exists) {
      throw Exception("No tracking data found for bookingId: $bookingId");
    }

    return BookingTrackingModel.fromJson(doc.data()!);
  }

  @override
  Future<String> createTrackingForBooking(
    String bookingId,
    List<BookingTrackingUpdateModel> updates,
  ) async {
    final docRef = await firestore.collection('booking_tracking').add({
      'bookingId': bookingId,
      'updates': updates.map((e) => e.toJson()).toList(),
    });
    await firestore.collection('bookings').doc(bookingId).update({
      'trackingId': docRef.id,
    });
    return docRef.id;
  }
}
