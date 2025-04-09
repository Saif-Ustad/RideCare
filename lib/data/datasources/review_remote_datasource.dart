import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/review_model.dart';

abstract class ReviewRemoteDataSource {
  Future<List<ReviewModel>> fetchReviews(String serviceProviderId);
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final FirebaseFirestore firestore;

  ReviewRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<ReviewModel>> fetchReviews(String serviceProviderId) async {
    final querySnapshot =
        await firestore
            .collection('reviews')
            .where('serviceProviderId', isEqualTo: serviceProviderId)
            .orderBy('createdAt', descending: true)
            .get();

    List<ReviewModel> reviewModels = [];

    for (var doc in querySnapshot.docs) {
      final reviewData = doc.data();
      final userId = reviewData['userId'];

      try {
        final userSnapshot =
            await firestore.collection('users').doc(userId).get();

        final userData = userSnapshot.data();

        if (userData != null) {
          final reviewModel = ReviewModel.fromJson(
            reviewData,
            userData,
            doc.id,
          );
          reviewModels.add(reviewModel);
        }
      } catch (e) {
        // Optionally handle error, or skip if user data not found
        print("Error fetching user for review: $e");
      }
    }

    return reviewModels;
  }
}
