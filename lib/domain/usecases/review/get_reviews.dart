import '../../entities/review_entity.dart';
import '../../repositories/review_repository.dart';

class GetReviews {
  final ReviewRepository repository;

  GetReviews({required this.repository});

  Future<List<ReviewEntity>> call(String serviceProviderId) {
    return repository.getReviews(serviceProviderId);
  }
}
