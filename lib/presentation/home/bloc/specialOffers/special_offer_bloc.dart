import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/specialOffers/get_special_offers.dart';
import 'special_offer_event.dart';
import 'special_offer_state.dart';

class SpecialOfferBloc extends Bloc<SpecialOfferEvent, SpecialOfferState> {
  final GetSpecialOffers getSpecialOffers;

  SpecialOfferBloc({required this.getSpecialOffers})
    : super(SpecialOfferInitial()) {
    on<FetchSpecialOffers>(_onFetchSpecialOffers);
  }

  Future<void> _onFetchSpecialOffers(
    FetchSpecialOffers event,
    Emitter<SpecialOfferState> emit,
  ) async {
    emit(SpecialOfferLoading());

    final result = await getSpecialOffers();

    result.fold(
      (failure) => emit(SpecialOfferError(failure.toString())),
      (offers) => emit(SpecialOfferLoaded(offers)),
    );
  }
}
