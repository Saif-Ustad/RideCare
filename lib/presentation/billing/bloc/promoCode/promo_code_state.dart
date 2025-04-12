import 'package:ridecare/domain/entities/promo_code_entity.dart';

abstract class PromoCodeState {}

class PromoCodeInitial extends PromoCodeState {}

class PromoCodeLoading extends PromoCodeState {}

class PromoCodeApplied extends PromoCodeState {
  final PromoCodeEntity promoCode;

  PromoCodeApplied(this.promoCode);
}

class PromoCodeInvalid extends PromoCodeState {}
