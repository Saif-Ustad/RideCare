import 'package:ridecare/domain/entities/promo_code_entity.dart';

import '../../domain/repositories/promo_code_repository.dart';
import '../datasources/promo_code_remote_datasource.dart';

class PromoCodeRepositoryImpl implements PromoCodeRepository {
  final PromoCodeRemoteDataSource remoteDataSource;

  PromoCodeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PromoCodeEntity?> validatePromoCode(
    String code,
    String serviceProviderId,
  ) async {
    return await remoteDataSource.validatePromoCode(code, serviceProviderId);
  }
}
