abstract class PromoCodeEvent {}

class ApplyPromoCodeEvent extends PromoCodeEvent {
  final String code;
  final String serviceProviderId;

  ApplyPromoCodeEvent({required this.code, required this.serviceProviderId});
}
