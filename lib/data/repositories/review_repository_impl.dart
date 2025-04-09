import 'package:ridecare/domain/entities/review_entity.dart';

import '../../domain/repositories/review_repository.dart';
import '../datasources/review_remote_datasource.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;

  ReviewRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ReviewEntity>> getReviews(String serviceProviderId) async {
    return await remoteDataSource.fetchReviews(serviceProviderId);
  }

}
