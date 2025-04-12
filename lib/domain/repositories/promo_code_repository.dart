import '../entities/promo_code_entity.dart';

abstract class PromoCodeRepository {
  Future<PromoCodeEntity?> validatePromoCode(String code, String serviceProviderId);
}
