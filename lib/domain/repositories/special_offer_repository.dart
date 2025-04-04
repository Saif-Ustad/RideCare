import 'package:dartz/dartz.dart';

import '../entities/special_offer_entity.dart';

abstract class SpecialOfferRepository {
  Future<Either<Exception, List<SpecialOffer>>> getSpecialOffers();
}
