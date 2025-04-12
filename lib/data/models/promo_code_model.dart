import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/promo_code_entity.dart';

class PromoCodeModel extends PromoCodeEntity {
  PromoCodeModel({
    required super.code,
    required super.discountPercentage,
    required super.validUntil,
    required super.applicableServiceProviderIds,
  });

  factory PromoCodeModel.fromJson(Map<String, dynamic> json) {
    final dynamic validUntilRaw = json['validUntil'];

    return PromoCodeModel(
      code: json['code'],
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      validUntil: validUntilRaw is Timestamp
          ? validUntilRaw.toDate()
          : DateTime.parse(validUntilRaw.toString()),
      applicableServiceProviderIds: List<String>.from(
        json['applicableServiceProviderIds'],
      ),
    );
  }
}
