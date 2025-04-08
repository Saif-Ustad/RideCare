import 'package:ridecare/data/datasources/bookmark_remote_datasource.dart';

import '../../domain/entities/service_provider_entity.dart';
import '../../domain/repositories/bookmark_repository.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  final BookmarkRemoteDataSource remoteDataSource;

  BookmarkRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ServiceProviderEntity>> getBookmarkedServices(String userId) {
    return remoteDataSource.getBookmarkedServices(userId);
  }

  @override
  Future<void> toggleBookmark(String userId, String serviceProviderId) {
    return remoteDataSource.toggleBookmark(userId, serviceProviderId);
  }
}
