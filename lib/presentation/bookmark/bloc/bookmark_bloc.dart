// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../domain/usecases/bookmark/get_bookmarked_service_providers.dart';
// import '../../../domain/usecases/bookmark/toggle_bookmark_service_provider.dart';
// import 'bookmark_event.dart';
// import 'bookmark_state.dart';
//
// class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
//   final GetBookmarkedServiceProviders getBookmarks;
//   final ToggleBookmarkedServiceProvider toggleBookmark;
//
//   BookmarkBloc({
//     required this.getBookmarks,
//     required this.toggleBookmark,
//   }) : super(BookmarkInitial()) {
//     on<LoadBookmarks>((event, emit) async {
//       emit(BookmarkLoading());
//       final result = await getBookmarks(event.userId);
//       emit(BookmarkLoaded(result));
//     });
//
//     on<ToggleBookmarkedServiceProviders>((event, emit) async {
//       await toggleBookmark(event.userId, event.serviceProviderId);
//       final updated = await getBookmarks(event.userId);
//       emit(BookmarkLoaded(updated));
//     });
//   }
// }

//
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../domain/entities/service_provider_entity.dart';
// import '../../../domain/usecases/bookmark/get_bookmarked_service_providers.dart';
// import '../../../domain/usecases/bookmark/toggle_bookmark_service_provider.dart';
// import 'bookmark_event.dart';
// import 'bookmark_state.dart';
//
// class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
//   final GetBookmarkedServiceProviders getBookmarks;
//   final ToggleBookmarkedServiceProvider toggleBookmark;
//
//   BookmarkBloc({
//     required this.getBookmarks,
//     required this.toggleBookmark,
//   }) : super(BookmarkInitial()) {
//     on<LoadBookmarks>(_onLoadBookmarks);
//     on<ToggleBookmarkedServiceProviders>(_onToggleBookmark);
//   }
//
//   Future<void> _onLoadBookmarks(
//       LoadBookmarks event,
//       Emitter<BookmarkState> emit,
//       ) async {
//     emit(BookmarkLoading());
//     try {
//       final result = await getBookmarks(event.userId);
//       emit(BookmarkLoaded(result));
//     } catch (e) {
//       emit(BookmarkError('Failed to load bookmarks: ${e.toString()}'));
//     }
//   }
//
//   Future<void> _onToggleBookmark(
//       ToggleBookmarkedServiceProviders event,
//       Emitter<BookmarkState> emit,
//       ) async {
//     if (state is! BookmarkLoaded) return;
//
//     final currentState = state as BookmarkLoaded;
//     final currentList = List<ServiceProviderEntity>.from(currentState.bookmarkedServiceProviders);
//
//     // Optimistically update the UI
//     final index = currentList.indexWhere((sp) => sp.id == event.serviceProviderId);
//     bool wasBookmarked = index != -1;
//
//     if (wasBookmarked) {
//       currentList.removeAt(index);
//     } else {
//       // We don’t have the provider in list if it wasn’t bookmarked before,
//       // so we wait for re-fetch after toggling to get fresh data.
//     }
//
//     emit(BookmarkLoaded(currentList));
//
//     try {
//       await toggleBookmark(event.userId, event.serviceProviderId);
//
//       // Re-fetch updated list from Firestore to stay in sync
//       final updated = await getBookmarks(event.userId);
//       emit(BookmarkLoaded(updated));
//     } catch (e) {
//       // Revert optimistic update on failure
//       final revertedList = List<ServiceProviderEntity>.from(currentState.bookmarkedServiceProviders);
//       emit(BookmarkLoaded(revertedList));
//       emit(BookmarkError('Bookmark update failed: ${e.toString()}'));
//     }
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common/helper/distance_matrix_helper.dart';
import '../../../common/helper/saveUserLocationToPrefs.dart';
import '../../../domain/entities/service_provider_entity.dart';
import '../../../domain/usecases/bookmark/get_bookmarked_service_providers.dart';
import '../../../domain/usecases/bookmark/toggle_bookmark_service_provider.dart';
import 'bookmark_event.dart';
import 'bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  final GetBookmarkedServiceProviders getBookmarks;
  final ToggleBookmarkedServiceProvider toggleBookmark;

  BookmarkBloc({required this.getBookmarks, required this.toggleBookmark})
    : super(BookmarkInitial()) {
    on<LoadBookmarks>(_onLoadBookmarks);
    on<ToggleBookmarkedServiceProviders>(_onToggleBookmark);
  }

  //
  // Future<void> _onLoadBookmarks(
  //   LoadBookmarks event,
  //   Emitter<BookmarkState> emit,
  // ) async {
  //   emit(BookmarkLoading());
  //   try {
  //     final result = await getBookmarks(event.userId);
  //     emit(BookmarkLoaded(result));
  //   } catch (e) {
  //     emit(BookmarkError('Failed to load bookmarks: ${e.toString()}'));
  //   }
  // }

  Future<void> _onLoadBookmarks(
    LoadBookmarks event,
    Emitter<BookmarkState> emit,
  ) async {
    emit(BookmarkLoading());
    try {
      final savedLocation = await getUserLocationFromPrefs();
      final bookmarks = await getBookmarks(event.userId);

      if (savedLocation != null && bookmarks.isNotEmpty) {
        final enriched = await DistanceMatrixHelper.addDistanceAndTime(
          userLat: savedLocation.latitude,
          userLng: savedLocation.longitude,
          providers: bookmarks,
        );
        emit(BookmarkLoaded(enriched));
      } else {
        emit(BookmarkLoaded(bookmarks));
      }
    } catch (e) {
      emit(BookmarkError('Failed to load bookmarks: ${e.toString()}'));
    }
  }

  Future<void> _onToggleBookmark(
    ToggleBookmarkedServiceProviders event,
    Emitter<BookmarkState> emit,
  ) async {
    if (state is! BookmarkLoaded) return;

    final currentState = state as BookmarkLoaded;
    final currentList = List<ServiceProviderEntity>.from(
      currentState.bookmarkedServiceProviders,
    );

    final index = currentList.indexWhere(
      (sp) => sp.id == event.serviceProvider.id,
    );
    final wasBookmarked = index != -1;

    if (wasBookmarked) {
      currentList.removeAt(index);
    } else {
      currentList.add(event.serviceProvider);
    }

    emit(BookmarkLoaded(currentList));

    try {
      await toggleBookmark(event.userId, event.serviceProvider.id);
    } catch (e) {
      emit(BookmarkLoaded(currentState.bookmarkedServiceProviders));
      emit(BookmarkError('Bookmark update failed: ${e.toString()}'));
    }
  }
}
