import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridecare/domain/usecases/booking/booking_created.dart';
import 'package:ridecare/domain/usecases/booking/booking_updated.dart';
import 'package:ridecare/domain/usecases/booking/prepare_booking_summary.dart';
import '../../../domain/entities/booking_entity.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingUpdatedUseCase bookingUpdatedUseCase;
  final BookingCreatedUseCase bookingCreatedUseCase;
  final PrepareBookingSummaryUseCase prepareBookingSummaryUseCase;

  BookingEntity _booking = BookingEntity();

  BookingBloc({
    required this.bookingUpdatedUseCase,
    required this.bookingCreatedUseCase,
    required this.prepareBookingSummaryUseCase,
  }) : super(BookingInitial()) {
    on<SelectService>((event, emit) {
      _booking = _booking.copyWith(
        serviceIds: event.serviceIds,
        serviceProviderId: event.providerId,
      );

      emit(BookingUpdated(booking: _booking));
    });

    on<SetAppointment>((event, emit) {
      _booking = _booking.copyWith(
        scheduledAt: event.date,
        note: event.note,
        serviceType: event.serviceType,
      );
      emit(BookingUpdated(booking: _booking));
    });

    on<SetVehicle>((event, emit) {
      _booking = _booking.copyWith(vehicleId: event.vehicleId);
      emit(BookingUpdated(booking: _booking));
    });

    on<SetAddress>((event, emit) {
      _booking = _booking.copyWith(addressId: event.addressId);
      emit(BookingUpdated(booking: _booking));
    });

    on<PrepareBillSummary>((event, emit) async {
      emit(BookingLoading());
      try {

        final bookingSummary = await prepareBookingSummaryUseCase(_booking);
        _booking = _booking.copyWith(services: bookingSummary.services, vehicle: bookingSummary.vehicle, address: bookingSummary.address, serviceProvider: bookingSummary.serviceProvider);

        print(
          "📝 Booking Updated: ${_booking.scheduledAt} ${_booking.note} ${_booking.serviceType} ${_booking.serviceIds} ${_booking.vehicleId} ${_booking.addressId} services: ${_booking.services} vehicle: ${_booking.vehicle} address: ${_booking.address} serviceProvider : ${_booking.serviceProvider}",
        );
        emit(BookingUpdated(booking: _booking));
      } catch (e) {
        emit(BookingError('Failed to prepare bill summary: $e'));
      }
    });

    on<SubmitBooking>((event, emit) async {
      emit(BookingLoading());
      try {
        final id = await bookingCreatedUseCase(_booking);
        emit(BookingSubmitted(id));
      } catch (e) {
        emit(BookingError(e.toString()));
      }
    });
  }
}
