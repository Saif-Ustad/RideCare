import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridecare/presentation/billing/bloc/promoCode/promo_code_event.dart';
import 'package:ridecare/presentation/billing/bloc/promoCode/promo_code_state.dart';

import '../../../../domain/usecases/promoCode/validate_promo_code.dart';

class PromoCodeBloc extends Bloc<PromoCodeEvent, PromoCodeState> {
  final ValidatePromoCodeUseCase validatePromoCodeUseCase;

  PromoCodeBloc({required this.validatePromoCodeUseCase})
    : super(PromoCodeInitial()) {
    on<ApplyPromoCodeEvent>((event, emit) async {
      emit(PromoCodeLoading());

      final promoCode = await validatePromoCodeUseCase(
        event.code,
        event.serviceProviderId,
      );
      if (promoCode != null) {
        emit(PromoCodeApplied(promoCode));
      } else {
        emit(PromoCodeInvalid());
      }
    });
  }
}
