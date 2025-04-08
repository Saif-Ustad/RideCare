import '../../repositories/bookmark_repository.dart';

class ToggleBookmarkedServiceProvider {
  final BookmarkRepository repository;

  ToggleBookmarkedServiceProvider({required this.repository});

  Future<void> call(String userId, String serviceProviderId) async {
    return repository.toggleBookmark(userId, serviceProviderId);
  }
}
