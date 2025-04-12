import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/booking_tracking_entity.dart';

class BookingTrackingUpdateModel extends BookingTrackingUpdateEntity {
  BookingTrackingUpdateModel({required super.status, required super.timestamp});

  factory BookingTrackingUpdateModel.fromJson(Map<String, dynamic> json) {
    return BookingTrackingUpdateModel(
      status: json['status'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  factory BookingTrackingUpdateModel.fromEntity(BookingTrackingUpdateEntity entity) {
    return BookingTrackingUpdateModel(
      status: entity.status,
      timestamp: entity.timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'timestamp': timestamp};
  }
}

class BookingTrackingModel extends BookingTrackingEntity {
  BookingTrackingModel({
    required super.bookingId,
    required List<BookingTrackingUpdateModel> super.updates,
  });

  factory BookingTrackingModel.fromJson(Map<String, dynamic> json) {
    return BookingTrackingModel(
      bookingId: json['bookingId'],
      updates:
          (json['updates'] as List)
              .map(
                (e) => BookingTrackingUpdateModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'updates':
          updates
              .map((e) => (e as BookingTrackingUpdateModel).toJson())
              .toList(),
    };
  }
}
