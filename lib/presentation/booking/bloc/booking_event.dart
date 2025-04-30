import 'dart:ffi';

import 'package:ridecare/domain/entities/booking_entity.dart';
import 'package:ridecare/domain/entities/booking_tracking_entity.dart';

import '../../../domain/entities/service_provider_entity.dart';

abstract class BookingEvent {}

class SelectService extends BookingEvent {
  final List<String> serviceIds;
  final String providerId;
  final ServiceProviderEntity serviceProvider;

  SelectService({required this.serviceIds, required this.providerId,  required this.serviceProvider,});
}

class SetAppointment extends BookingEvent {
  final DateTime date;
  final String? note;
  final String serviceType;

  SetAppointment({required this.date, this.note, required this.serviceType});
}

class SetVehicle extends BookingEvent {
  final String vehicleId;

  SetVehicle({required this.vehicleId});
}

class SetAddress extends BookingEvent {
  final String addressId;

  SetAddress({required this.addressId});
}

class PrepareBillSummary extends BookingEvent {}

class ApplyPromoCode extends BookingEvent {
  final String promoCode;
  final double discountPercentage;

  ApplyPromoCode({required this.promoCode, required this.discountPercentage});
}

class SetTotalAmount extends BookingEvent {
  final double totalAmount;

  SetTotalAmount({required this.totalAmount});
}

class SubmitBooking extends BookingEvent {
  final String paymentMode;

  SubmitBooking({required this.paymentMode});
}

class GetAllBookings extends BookingEvent {
  final String userId;

  GetAllBookings({required this.userId});
}

class CancelBooking extends BookingEvent {
  final String bookingId;
  final String userId;

  CancelBooking({required this.bookingId, required this.userId});
}

