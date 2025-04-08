import '../../entities/service_provider_entity.dart';
import '../../repositories/bookmark_repository.dart';

class GetBookmarkedServiceProviders {
  final BookmarkRepository repository;

  GetBookmarkedServiceProviders({required this.repository});

  Future<List<ServiceProviderEntity>> call(String userId) {
    return repository.getBookmarkedServices(userId);
  }
}
