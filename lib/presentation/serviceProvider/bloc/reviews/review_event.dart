import 'package:equatable/equatable.dart';

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

