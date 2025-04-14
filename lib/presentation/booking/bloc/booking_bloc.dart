import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridecare/domain/entities/user_entity.dart';
import 'package:ridecare/domain/usecases/booking/booking_created.dart';
import 'package:ridecare/domain/usecases/booking/booking_updated.dart';
import 'package:ridecare/domain/usecases/booking/get_all_booking_usecase.dart';
import 'package:ridecare/domain/usecases/booking/prepare_booking_summary.dart';
import 'package:ridecare/domain/usecases/booking_tracking/create_booking_tracking_usecase.dart';
import '../../../domain/entities/booking_entity.dart';
import '../../../domain/entities/booking_tracking_entity.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingUpdatedUseCase bookingUpdatedUseCase;
  final BookingCreatedUseCase bookingCreatedUseCase;
  final PrepareBookingSummaryUseCase prepareBookingSummaryUseCase;
  final CreateBookingTrackingUseCase createBookingTrackingUseCase;
  final GetAllBookingUseCase getAllBookingUseCase;

  BookingEntity _booking = BookingEntity();

  BookingBloc({
    required this.bookingUpdatedUseCase,
    required this.bookingCreatedUseCase,
    required this.prepareBookingSummaryUseCase,
    required this.createBookingTrackingUseCase,
    required this.getAllBookingUseCase,
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
        _booking = _booking.copyWith(
          services: bookingSummary.services,
          vehicleInfo: bookingSummary.vehicleInfo,
          addressInfo: bookingSummary.addressInfo,
          serviceProvider: bookingSummary.serviceProvider,
        );

        emit(BookingUpdated(booking: _booking));
      } catch (e) {
        emit(BookingError('Failed to prepare bill summary: $e'));
      }
    });

    on<ApplyPromoCode>((event, emit) {
      _booking = _booking.copyWith(
        promoCodeInfo: {
          'code': event.promoCode,
          'discountPercentage': event.discountPercentage,
        },
      );

      emit(BookingUpdated(booking: _booking));
    });

    on<SetTotalAmount>((event, emit) {
      _booking = _booking.copyWith(totalCharges: event.totalAmount);
      print("📝 Booking Updated: ${_booking.totalCharges}");

      emit(BookingUpdated(booking: _booking));
    });

    on<SubmitBooking>((event, emit) async {
      emit(BookingLoading());
      try {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          final userDoc =
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser.uid)
                  .get();

          final userData = userDoc.data();

          if (userData != null) {
            _booking = _booking.copyWith(
              status: "Order Pending",
              paymentMode: event.paymentMode,
              userId: currentUser.uid,
              user: UserEntity(
                uid: currentUser.uid,
                email: userData['email'],
                displayName: "${userData['firstName']} ${userData['lastName']}",
              ),
            );
          } else {
            emit(BookingError("User data not found"));
            return;
          }
        } else {
          emit(BookingError("User not logged in"));
          return;
        }

        final id = await bookingCreatedUseCase(_booking);
        final now = _booking.scheduledAt;

        await createBookingTrackingUseCase(id, [
          BookingTrackingUpdateEntity(status: "Order Pending", timestamp: now!),
          BookingTrackingUpdateEntity(
            status: "Order Accepted",
            timestamp: now.add(Duration(hours: 2)),
          ),
          BookingTrackingUpdateEntity(
            status: "Car Received at Center",
            timestamp: now.add(Duration(hours: 5)),
          ),
          BookingTrackingUpdateEntity(
            status: "Order in Progressed",
            timestamp: now.add(Duration(hours: 8)),
          ),
          BookingTrackingUpdateEntity(
            status: "Ready for Pick or Delivery",
            timestamp: now.add(Duration(hours: 12)),
          ),
          BookingTrackingUpdateEntity(
            status: "Delivered",
            timestamp: now.add(Duration(hours: 24)),
          ),
        ]);

        emit(BookingSubmitted(id));
        _booking = BookingEntity();
      } catch (e) {
        emit(BookingError(e.toString()));
      }
    });

    on<GetAllBookings>((event, emit) async {
      emit(BookingLoading());

      try {
        final bookings = await getAllBookingUseCase(event.userId);
        emit(BookingsLoaded(bookings));
      } catch (e) {
        emit(BookingError(e.toString()));
      }
    });

    on<CancelBooking>((event, emit) async {
      emit(BookingLoading());

      try {
        await bookingUpdatedUseCase(event.bookingId, {'status': 'Order Cancelled'});

        final bookings = await getAllBookingUseCase(event.userId);
        emit(BookingsLoaded(bookings));
      } catch (e) {
        emit(BookingError("Failed to cancel booking: $e"));
      }
    });
  }
}
