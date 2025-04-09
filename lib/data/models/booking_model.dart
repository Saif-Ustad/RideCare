import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/booking_entity.dart';

class BookingModel extends BookingEntity {
  BookingModel({
    super.bookingId,
    super.serviceIds,
    super.serviceProviderId,
    super.scheduledAt,
    super.note,
    super.vehicleId,
    super.addressId,
    super.userId,
    super.trackingId,
    super.paymentStatus,
    super.status,
    super.serviceType,
  });

  // Converts Firestore document to BookingModel
  factory BookingModel.fromJson(Map<String, dynamic> json, String id) {
    return BookingModel(
      bookingId: id,
      serviceIds: List<String>.from(json['serviceIds'] ?? []),
      serviceProviderId: json['serviceProviderId'],
      scheduledAt: (json['scheduledAt'] as Timestamp?)?.toDate(),
      note: json['note'],
      vehicleId: json['vehicleId'],
      addressId: json['addressId'],
      userId: json['userId'],
      trackingId: json['trackingId'],
      paymentStatus: json['paymentStatus'],
      status: json['status'],
      serviceType: json['serviceType'],
    );
  }

  // Converts BookingModel to JSON map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'serviceIds': serviceIds,
      'serviceProviderId': serviceProviderId,
      'scheduledAt':
          scheduledAt != null ? Timestamp.fromDate(scheduledAt!) : null,
      'note': note,
      'vehicleId': vehicleId,
      'addressId': addressId,
      'userId': userId,
      'trackingId': trackingId,
      'paymentStatus': paymentStatus,
      'status': status,
      'serviceType': serviceType,
    };
  }

  // ✅ Add this method to convert BookingEntity to BookingModel
  factory BookingModel.fromEntity(BookingEntity entity) {
    return BookingModel(
      bookingId: entity.bookingId,
      serviceIds: entity.serviceIds,
      serviceProviderId: entity.serviceProviderId,
      scheduledAt: entity.scheduledAt,
      note: entity.note,
      vehicleId: entity.vehicleId,
      addressId: entity.addressId,
      userId: entity.userId,
      trackingId: entity.trackingId,
      paymentStatus: entity.paymentStatus,
      status: entity.status,
      serviceType: entity.serviceType,
    );
  }
}
