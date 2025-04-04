import 'package:dartz/dartz.dart';
import '../../domain/entities/special_offer_entity.dart';
import '../../domain/repositories/special_offer_repository.dart';
import '../datasources/special_offer_remote_datasource.dart';


class SpecialOfferRepositoryImpl implements SpecialOfferRepository {
  final SpecialOfferRemoteDataSource remoteDataSource;

  SpecialOfferRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Exception, List<SpecialOffer>>> getSpecialOffers() async {
    try {
      final specialOffers = await remoteDataSource.getSpecialOffers();
      return Right(specialOffers);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }
}
