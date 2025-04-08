import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/bookmark/get_bookmarked_service_providers.dart';
import '../../../domain/usecases/bookmark/toggle_bookmark_service_provider.dart';
import 'bookmark_event.dart';
import 'bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  final GetBookmarkedServiceProviders getBookmarks;
  final ToggleBookmarkedServiceProvider toggleBookmark;

  BookmarkBloc({
    required this.getBookmarks,
    required this.toggleBookmark,
  }) : super(BookmarkInitial()) {
    on<LoadBookmarks>((event, emit) async {
      emit(BookmarkLoading());
      final result = await getBookmarks(event.userId);
      emit(BookmarkLoaded(result));
    });

    on<ToggleBookmarkedServiceProviders>((event, emit) async {
      await toggleBookmark(event.userId, event.serviceProviderId);
      final updated = await getBookmarks(event.userId);
      emit(BookmarkLoaded(updated));
    });
  }
}
