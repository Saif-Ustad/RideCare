import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/special_offer_model.dart';

abstract class SpecialOfferRemoteDataSource {
  Future<List<SpecialOfferModel>> getSpecialOffers();
}

class SpecialOfferRemoteDataSourceImpl implements SpecialOfferRemoteDataSource {
  final FirebaseFirestore firestore;

  SpecialOfferRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<SpecialOfferModel>> getSpecialOffers() async {
    try {
      final snapshot = await firestore.collection('specialOffers').get();
      return snapshot.docs
          .map((doc) => SpecialOfferModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception("Failed to load special offers: $e");
    }
  }
}
