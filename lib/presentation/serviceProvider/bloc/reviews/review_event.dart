import 'package:equatable/equatable.dart';

import '../../../../domain/entities/review_entity.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object?> get props => [];
}

class LoadReviews extends ReviewEvent {
  final String serviceProviderId;

  const LoadReviews(this.serviceProviderId);

  @override
  List<Object?> get props => [serviceProviderId];
}

class FilterReviewsByVerified extends ReviewEvent {
  const FilterReviewsByVerified();
}

class FilterReviewsWithPhotos extends ReviewEvent {
  const FilterReviewsWithPhotos();
}

class SortReviewsByLatest extends ReviewEvent {
  const SortReviewsByLatest();
}

class SearchReviews extends ReviewEvent {
  final String query;

  const SearchReviews(this.query);

  @override
  List<Object?> get props => [query];
}

class AddReview extends ReviewEvent {
  final ReviewEntity review;

  const AddReview(this.review);
}

class DeleteReview extends ReviewEvent {
  final String reviewId;

  const DeleteReview(this.reviewId);
}
