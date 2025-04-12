import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/promo_code_entity.dart';
import '../models/promo_code_model.dart';

abstract class PromoCodeRemoteDataSource {
  Future<PromoCodeEntity?> validatePromoCode(
    String code,
    String serviceProviderId,
  );
}

class PromoCodeRemoteDataSourceImpl implements PromoCodeRemoteDataSource {
  final FirebaseFirestore firestore;

  PromoCodeRemoteDataSourceImpl({required this.firestore});

  @override
  Future<PromoCodeEntity?> validatePromoCode(
    String code,
    String serviceProviderId,
  ) async {
    final query =
        await firestore
            .collection('promo_codes')
            .where('code', isEqualTo: code)
            .get();

    if (query.docs.isEmpty) return null;

    final data = query.docs.first.data();
    final promoCode = PromoCodeModel.fromJson(data);

    if (promoCode.validUntil.isBefore(DateTime.now())) return null;

    if (!promoCode.applicableServiceProviderIds.contains(serviceProviderId)) {
      return null;
    }

    return promoCode;
  }
}
