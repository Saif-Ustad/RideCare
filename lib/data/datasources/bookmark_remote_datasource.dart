
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/service_provider_entity.dart';

abstract class BookmarkRemoteDataSource {
  Future<List<ServiceProviderEntity>> getBookmarkedServices(String userId);
  Future<void> toggleBookmark(String userId, String serviceProviderId);
}

class BookmarkRemoteDataSourceImpl implements BookmarkRemoteDataSource {
  final FirebaseFirestore firestore;
  BookmarkRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<ServiceProviderEntity>> getBookmarkedServices(String userId) async {
    final userDoc = await firestore.collection('users').doc(userId).get();
    final bookmarkIds = List<String>.from(userDoc.data()?['bookmarkIds'] ?? []);

    final snapshot = await firestore
        .collection('service_providers')
        .where(FieldPath.documentId, whereIn: bookmarkIds.isEmpty ? ['none'] : bookmarkIds)
        .get();

    return snapshot.docs.map((doc) => _mapToServiceProvider(doc)).toList();
  }

  @override
  Future<void> toggleBookmark(String userId, String serviceProviderId) async {
    final userRef = firestore.collection('users').doc(userId);
    final snapshot = await userRef.get();
    final currentBookmarks = List<String>.from(snapshot.data()?['bookmarkIds'] ?? []);

    if (currentBookmarks.contains(serviceProviderId)) {
      currentBookmarks.remove(serviceProviderId);
    } else {
      currentBookmarks.add(serviceProviderId);
    }

    await userRef.update({'bookmarkIds': currentBookmarks});
  }

  ServiceProviderEntity _mapToServiceProvider(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ServiceProviderEntity(
      id: doc.id,
      name: data['name'] ?? '',
      ownerName: data['ownerName'] ?? '',
      about: data['about'] ?? '',
      contactPhone: data['contactPhone'] ?? '',
      experienceYears: data['experienceYears'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      workImageUrl: data['workImageUrl'] ?? '',
      galleryImageUrls: List<String>.from(data['galleryImageUrls'] ?? []),
      rating: (data['rating'] ?? 0).toDouble(),
      reviewsCount: data['reviewsCount'] ?? 0,
      availability: AvailabilityEntity(
        from: data['availability']['from'],
        to: data['availability']['to'],
      ),
      location: LocationEntity(
        address: data['location']['address'],
        lat: data['location']['lat'],
        lng: data['location']['lng'],
      ),
      serviceCharges: ServiceChargesEntity(
        min: data['serviceCharges']['min'],
        max: data['serviceCharges']['max'],
      ),
      categoryIds: List<String>.from(data['categoryIds'] ?? []),
      providerServiceIds: List<String>.from(data['providerServiceIds'] ?? []),
    );
  }
}