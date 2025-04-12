import 'dart:ffi';

import 'package:ridecare/domain/entities/address_entity.dart';
import 'package:ridecare/domain/entities/service_entity.dart';
import 'package:ridecare/domain/entities/service_provider_entity.dart';
import 'package:ridecare/domain/entities/user_entity.dart';
import 'package:ridecare/domain/entities/vehicle_entity.dart';

class BookingEntity {
  final String? bookingId;
  final List<String>? serviceIds;
  final List<ServiceEntity>? services;
  final String? serviceProviderId;
  final ServiceProviderEntity? serviceProvider;
  final DateTime? scheduledAt;
  final String? note;
  final String? vehicleId;
  final VehicleEntity? vehicle;
  final String? addressId;
  final AddressEntity? address;
  final String? userId;
  final UserEntity? user;
  final String? trackingId;
  final String? paymentStatus;
  final String? status;
  final String? serviceType;
  final double? totalCharges;
  final Map<String, dynamic>? promoCodeInfo;

  BookingEntity({
    this.bookingId,
    this.serviceIds,
    this.services,
    this.serviceProviderId,
    this.serviceProvider,
    this.scheduledAt,
    this.note,
    this.vehicleId,
    this.vehicle,
    this.addressId,
    this.address,
    this.userId,
    this.user,
    this.trackingId,
    this.paymentStatus,
    this.status,
    this.serviceType,
    this.totalCharges,
    this.promoCodeInfo,
  });

  BookingEntity copyWith({
    List<String>? serviceIds,
    List<ServiceEntity>? services,
    String? serviceProviderId,
    ServiceProviderEntity? serviceProvider,
    DateTime? scheduledAt,
    String? note,
    String? vehicleId,
    VehicleEntity? vehicle,
    String? addressId,
    AddressEntity? address,
    String? paymentStatus,
    String? status,
    String? trackingId,
    String? userId,
    UserEntity? user,
    String? serviceType,
    double? totalCharges,
    Map<String, dynamic>? promoCodeInfo,
  }) {
    return BookingEntity(
      bookingId: bookingId,
      serviceIds: serviceIds ?? this.serviceIds,
      services: services ?? this.services,
      serviceProviderId: serviceProviderId ?? this.serviceProviderId,
      serviceProvider: serviceProvider ?? this.serviceProvider,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      note: note ?? this.note,
      vehicleId: vehicleId ?? this.vehicleId,
      vehicle: vehicle ?? this.vehicle,
      addressId: addressId ?? this.addressId,
      address: address ?? this.address,
      trackingId: trackingId ?? this.trackingId,
      userId: userId ?? this.userId,
      user: user ?? this.user,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      status: status ?? this.status,
      serviceType: serviceType ?? this.serviceType,
      totalCharges: totalCharges ?? this.totalCharges,
      promoCodeInfo: promoCodeInfo ?? this.promoCodeInfo,
    );
  }
}
