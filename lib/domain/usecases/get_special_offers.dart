import 'package:dartz/dartz.dart';
import '../entities/special_offer_entity.dart';
import '../repositories/special_offer_repository.dart';

class GetSpecialOffers {
  final SpecialOfferRepository repository;

  GetSpecialOffers({required this.repository});

  Future<Either<Exception, List<SpecialOffer>>> call() {
    return repository.getSpecialOffers();
  }
}
