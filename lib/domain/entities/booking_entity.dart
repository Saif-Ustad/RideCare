class BookingEntity {
  final String? bookingId;
  final List<String>? serviceIds;
  final String? serviceProviderId;
  final DateTime? scheduledAt;
  final String? note;
  final String? vehicleId;
  final String? addressId;
  final String? userId;
  final String? trackingId;
  final String? paymentStatus;
  final String? status;
  final String? serviceType;

  BookingEntity({
    this.bookingId,
    this.serviceIds,
    this.serviceProviderId,
    this.scheduledAt,
    this.note,
    this.vehicleId,
    this.addressId,
    this.userId,
    this.trackingId,
    this.paymentStatus,
    this.status,
    this.serviceType,
  });

  BookingEntity copyWith({
    List<String>? serviceIds,
    String? serviceProviderId,
    DateTime? scheduledAt,
    String? note,
    String? vehicleId,
    String? addressId,
    String? paymentStatus,
    String? status,
    String? trackingId,
    String? userId,
    String? serviceType,
  }) {
    return BookingEntity(
      bookingId: bookingId,
      serviceIds: serviceIds ?? this.serviceIds,
      serviceProviderId: serviceProviderId ?? this.serviceProviderId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      note: note ?? this.note,
      vehicleId: vehicleId ?? this.vehicleId,
      addressId: addressId ?? this.addressId,
      trackingId: trackingId ?? this.trackingId,
      userId: userId ?? this.userId,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      status: status ?? this.status,
      serviceType: serviceType ?? this.serviceType,
    );
  }
}
