import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/review_entity.dart';
import '../../../../domain/usecases/review/get_reviews.dart';
import 'review_event.dart';
import 'review_state.dart';

// class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
//   final GetReviews getReviewsUseCase;
//
//   List<ReviewEntity> _allReviews = [];
//
//   // Active filters state
//   bool _showVerified = false;
//   bool _showWithPhotos = false;
//   bool _sortByLatest = false;
//
//   ReviewBloc({required this.getReviewsUseCase}) : super(ReviewInitial()) {
//     on<LoadReviews>(_onLoadReviews);
//     on<FilterReviewsByVerified>(_onToggleVerified);
//     on<FilterReviewsWithPhotos>(_onToggleWithPhotos);
//     on<SortReviewsByLatest>(_onToggleSortByLatest);
//   }
//
//   Future<void> _onLoadReviews(
//     LoadReviews event,
//     Emitter<ReviewState> emit,
//   ) async {
//     emit(ReviewLoading());
//     try {
//       final reviews = await getReviewsUseCase(event.serviceProviderId);
//       _allReviews = reviews;
//       _applyFilters(emit);
//     } catch (e) {
//       emit(ReviewError('Failed to load reviews'));
//     }
//   }
//
//   void _onToggleVerified(
//     FilterReviewsByVerified event,
//     Emitter<ReviewState> emit,
//   ) {
//     _showVerified = !_showVerified;
//     _applyFilters(emit);
//   }
//
//   void _onToggleWithPhotos(
//     FilterReviewsWithPhotos event,
//     Emitter<ReviewState> emit,
//   ) {
//     _showWithPhotos = !_showWithPhotos;
//     _applyFilters(emit);
//   }
//
//   void _onToggleSortByLatest(
//     SortReviewsByLatest event,
//     Emitter<ReviewState> emit,
//   ) {
//     _sortByLatest = !_sortByLatest;
//     _applyFilters(emit);
//   }
//
//   void _applyFilters(Emitter<ReviewState> emit) {
//     List<ReviewEntity> filtered = [..._allReviews];
//
//     if (_showVerified) {
//       filtered = filtered.where((r) => r.isVerified).toList();
//     }
//
//     if (_showWithPhotos) {
//       filtered = filtered.where((r) => r.imageUrls.isNotEmpty).toList();
//     }
//
//     if (_sortByLatest) {
//       filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
//     }
//
//     emit(ReviewLoaded(filtered));
//   }
// }

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final GetReviews getReviewsUseCase;

  List<ReviewEntity> _allReviews = [];
  final Set<String> _activeFilters = {};

  ReviewBloc({required this.getReviewsUseCase}) : super(ReviewInitial()) {
    on<LoadReviews>(_onLoadReviews);
    on<FilterReviewsByVerified>(_onFilterVerified);
    on<SortReviewsByLatest>(_onSortByLatest);
    on<FilterReviewsWithPhotos>(_onFilterWithPhotos);
    on<SearchReviews>(_onSearchReviews);

  }

  Future<void> _onLoadReviews(LoadReviews event, Emitter<ReviewState> emit) async {
    emit(ReviewLoading());
    _activeFilters.clear(); // Reset filters on reload
    try {
      _allReviews = await getReviewsUseCase(event.serviceProviderId);
      emit(ReviewLoaded(_allReviews, activeFilters: _activeFilters));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  void _onFilterVerified(FilterReviewsByVerified event, Emitter<ReviewState> emit) {
    if (_activeFilters.contains("Verified")) {
      _activeFilters.remove("Verified");
    } else {
      _activeFilters.add("Verified");
    }
    emit(ReviewLoaded(_applyActiveFilters(), activeFilters: _activeFilters));
  }

  void _onFilterWithPhotos(FilterReviewsWithPhotos event, Emitter<ReviewState> emit) {
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
    final query = event.query.toLowerCase();
    final filtered = _applyActiveFilters().where((review) {
      return review.reviewText.toLowerCase().contains(query) ||
          review.userName.toLowerCase().contains(query); // Customize fields
    }).toList();

    emit(ReviewLoaded(filtered, activeFilters: _activeFilters));
  }


  /// 🔁 Combines all active filters
  List<ReviewEntity> _applyActiveFilters() {
    List<ReviewEntity> filtered = List.from(_allReviews);

    if (_activeFilters.contains("Verified")) {
      filtered = filtered.where((r) => r.isVerified).toList();
    }

    if (_activeFilters.contains("With Photos")) {
      filtered = filtered.where((r) => r.imageUrls.isNotEmpty).toList();
    }

    if (_activeFilters.contains("Latest")) {
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return filtered;
  }
}
