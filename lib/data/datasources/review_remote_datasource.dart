import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/review_model.dart';

abstract class ReviewRemoteDataSource {
  Future<List<ReviewModel>> fetchReviews(String serviceProviderId);

  Future<void> addReview(ReviewModel review);
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
            // .orderBy('createdAt', descending: true)
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

  @override
  Future<void> addReview(ReviewModel review) async {
    final docRef = await firestore.collection('reviews').add({
      'userId': review.userId,
      'userName': review.userName,
      'serviceProviderId': review.serviceProviderId,
      'reviewText': review.reviewText,
      'ratings': review.ratings,
      'isVerified': review.isVerified,
      if (review.imageUrls != null) 'imageUrls': review.imageUrls,
      'createdAt': review.createdAt,
    });

    final reviewId = docRef.id;

    final userRef = firestore.collection('users').doc(review.userId);

    await userRef.update({
      'reviewIds': FieldValue.arrayUnion([reviewId]),
    });
  }
}
