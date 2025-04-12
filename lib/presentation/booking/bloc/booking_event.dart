import 'dart:ffi';

abstract class BookingEvent {}

class SelectService extends BookingEvent {
  final List<String> serviceIds;
  final String providerId;

  SelectService({required this.serviceIds, required this.providerId});
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

class SubmitBooking extends BookingEvent {}
