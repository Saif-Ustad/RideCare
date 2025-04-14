import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/usecases/booking_tracking/get_booking_tracking_usecase.dart';
import 'booking_tracking_event.dart';
import 'booking_tracking_state.dart';

class BookingTrackingBloc
    extends Bloc<BookingTrackingEvent, BookingTrackingState> {
  final GetBookingTrackingUseCase getBookingTrackingUseCase;

  BookingTrackingBloc({required this.getBookingTrackingUseCase})
    : super(BookingTrackingInitial()) {
    on<GetBookingTrackingInfo>((event, emit) async {
      emit(BookingTrackingLoading());
      try {
        final tracking = await getBookingTrackingUseCase(event.bookingId);
        emit(BookingTrackingLoaded(tracking));
      } catch (e) {
        emit(BookingTrackingError("Failed to fetch tracking: $e"));
      }
    });
  }
}
