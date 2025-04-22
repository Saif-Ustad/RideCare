import 'package:ridecare/domain/entities/review_entity.dart';

abstract class ReviewRepository {
  Future<List<ReviewEntity>> getReviews(String serviceProviderId);
  Future<void> addReview(ReviewEntity review);
  Future<void> deleteReview(String reviewId);
}
