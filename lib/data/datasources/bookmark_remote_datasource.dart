import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/service_provider_entity.dart';
import '../models/service_provider_model.dart';

abstract class BookmarkRemoteDataSource {
  Future<List<ServiceProviderEntity>> getBookmarkedServices(String userId);

  Future<void> toggleBookmark(String userId, String serviceProviderId);
}

class BookmarkRemoteDataSourceImpl implements BookmarkRemoteDataSource {
  final FirebaseFirestore firestore;

  BookmarkRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<ServiceProviderEntity>> getBookmarkedServices(
    String userId,
  ) async {
    final userDoc = await firestore.collection('users').doc(userId).get();
    final bookmarkIds = List<String>.from(userDoc.data()?['bookmarkIds'] ?? []);

    final snapshot =
        await firestore
            .collection('service_providers')
            .where(
              FieldPath.documentId,
              whereIn: bookmarkIds.isEmpty ? ['none'] : bookmarkIds,
            )
            .get();

    return snapshot.docs
        .map((doc) => ServiceProviderModel.fromJson(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<void> toggleBookmark(String userId, String serviceProviderId) async {
    final userRef = firestore.collection('users').doc(userId);

    final userSnapshot = await userRef.get();
    final currentBookmarks = List<String>.from(
      userSnapshot.data()?['bookmarkIds'] ?? [],
    );

    if (currentBookmarks.contains(serviceProviderId)) {
      await userRef.update({
        'bookmarkIds': FieldValue.arrayRemove([serviceProviderId]),
      });
    } else {
      await userRef.update({
        'bookmarkIds': FieldValue.arrayUnion([serviceProviderId]),
      });
    }
  }
}
