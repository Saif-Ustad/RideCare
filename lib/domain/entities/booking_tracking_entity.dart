import 'package:cloud_firestore/cloud_firestore.dart';

class BookingTrackingUpdateEntity {
  final String status;
  final DateTime timestamp;

  BookingTrackingUpdateEntity({required this.status, required this.timestamp});

  factory BookingTrackingUpdateEntity.fromJson(Map<String, dynamic> json) =>
      BookingTrackingUpdateEntity(
        status: json['status'],
        timestamp: (json['timestamp'] as Timestamp).toDate(),
      );
}

class BookingTrackingEntity {
  final String bookingId;
  final List<BookingTrackingUpdateEntity> updates;

  BookingTrackingEntity({required this.bookingId, required this.updates});

  factory BookingTrackingEntity.fromJson(Map<String, dynamic> json) =>
      BookingTrackingEntity(
        bookingId: json['bookingId'],
        updates:
            (json['updates'] as List<dynamic>)
                .map((e) => BookingTrackingUpdateEntity.fromJson(e))
                .toList(),
      );
}
