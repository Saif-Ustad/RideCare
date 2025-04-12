import '../../entities/promo_code_entity.dart';
import '../../repositories/promo_code_repository.dart';

class ValidatePromoCodeUseCase {
  final PromoCodeRepository repository;

  ValidatePromoCodeUseCase({required this.repository});

  Future<PromoCodeEntity?> call(String code, String serviceProviderId) {
    return repository.validatePromoCode(code, serviceProviderId);
  }
}
