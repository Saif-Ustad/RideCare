import '../../entities/review_entity.dart';
import '../../repositories/review_repository.dart';

class AddReviewUseCase {
  final ReviewRepository repository;

  AddReviewUseCase({required this.repository});

  Future<void> call(ReviewEntity review) {
    return repository.addReview(review);
  }
}
