import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/review_entity.dart';
import '../../../../domain/usecases/review/add_review.dart';
import '../../../../domain/usecases/review/get_reviews.dart';
import 'review_event.dart';
import 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final GetReviewsUseCase getReviewsUseCase;
  final AddReviewUseCase addReviewUseCase;

  List<ReviewEntity> _allReviews = [];
  final Set<String> _activeFilters = {};
  String _searchQuery = '';

  ReviewBloc({required this.getReviewsUseCase, required this.addReviewUseCase})
    : super(ReviewInitial()) {
    on<LoadReviews>(_onLoadReviews);
    on<FilterReviewsByVerified>(_onFilterVerified);
    on<SortReviewsByLatest>(_onSortByLatest);
    on<FilterReviewsWithPhotos>(_onFilterWithPhotos);
    on<SearchReviews>(_onSearchReviews);
    on<AddReview>(_onAddReview);
  }

  Future<void> _onLoadReviews(
    LoadReviews event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoading());
    _activeFilters.clear(); // Reset filters on reload
    _searchQuery = '';
    try {
      _allReviews = await getReviewsUseCase(event.serviceProviderId);
      emit(ReviewLoaded(_allReviews, activeFilters: _activeFilters));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  void _onFilterVerified(
    FilterReviewsByVerified event,
    Emitter<ReviewState> emit,
  ) {
    if (_activeFilters.contains("Verified")) {
      _activeFilters.remove("Verified");
    } else {
      _activeFilters.add("Verified");
    }
    emit(ReviewLoaded(_applyActiveFilters(), activeFilters: _activeFilters));
  }

  void _onFilterWithPhotos(
    FilterReviewsWithPhotos event,
    Emitter<ReviewState> emit,
  ) {
    if (_activeFilters.contains("With Photos")) {
      _activeFilters.remove("With Photos");
    } else {
      _activeFilters.add("With Photos");
    }
    emit(ReviewLoaded(_applyActiveFilters(), activeFilters: _activeFilters));
  }

  void _onSortByLatest(SortReviewsByLatest event, Emitter<ReviewState> emit) {
    if (_activeFilters.contains("Latest")) {
      _activeFilters.remove("Latest");
    } else {
      _activeFilters.add("Latest");
    }
    emit(ReviewLoaded(_applyActiveFilters(), activeFilters: _activeFilters));
  }

  void _onSearchReviews(SearchReviews event, Emitter<ReviewState> emit) {
    _searchQuery = event.query.toLowerCase(); // ✅ Update search query
    emit(ReviewLoaded(_applyActiveFilters(), activeFilters: _activeFilters));
  }

  /// 🔁 Combines all active filters
  List<ReviewEntity> _applyActiveFilters() {
    List<ReviewEntity> filtered = List.from(_allReviews);

    if (_activeFilters.contains("Verified")) {
      filtered = filtered.where((r) => r.isVerified).toList();
    }

    if (_activeFilters.contains("With Photos")) {
      filtered = filtered.where((r) => r.imageUrls != null && r.imageUrls!.isNotEmpty).toList();
    }

    if (_activeFilters.contains("Latest")) {
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    if (_searchQuery.isNotEmpty) {
      filtered =
          filtered.where((review) {
            return review.reviewText.toLowerCase().contains(_searchQuery) ||
                review.userName.toLowerCase().contains(_searchQuery);
          }).toList();
    }

    return filtered;
  }

  Future<void> _onAddReview(AddReview event, Emitter<ReviewState> emit) async {
    emit(ReviewSubmitting());
    try {
      await addReviewUseCase(event.review);
      emit(ReviewAddedSuccessfully());
      add(LoadReviews(event.review.serviceProviderId));
      emit(ReviewLoaded(_applyActiveFilters(), activeFilters: _activeFilters));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }
}
