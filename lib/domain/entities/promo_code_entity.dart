class PromoCodeEntity {
  final String code;
  final double discountPercentage;
  final DateTime validUntil;
  final List<String> applicableServiceProviderIds;

  PromoCodeEntity({
    required this.code,
    required this.discountPercentage,
    required this.validUntil,
    required this.applicableServiceProviderIds,
  });
}
