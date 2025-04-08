import '../entities/service_provider_entity.dart';

abstract class BookmarkRepository {
  Future<List<ServiceProviderEntity>> getBookmarkedServices(String userId);
  Future<void> toggleBookmark(String userId, String serviceProviderId);
}