import 'package:ridecare/domain/repositories/review_repository.dart';

class DeleteReviewUseCase {
  ReviewRepository repository;

  DeleteReviewUseCase({required this.repository});

  Future<void> call(String reviewId) {
    return repository.deleteReview(reviewId);
  }
}
