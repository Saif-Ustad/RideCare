import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../common/helper/uploadImageToCloudinary.dart';
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
        print("Error fetching user for review: $e");
      }
    }

    return reviewModels;
  }

  @override
  Future<void> addReview(ReviewModel review) async {
    List<String> uploadedImageUrls = [];

    print("images ${review.imageUrls}");

    if (review.imageUrls != null && review.imageUrls!.isNotEmpty) {
      for (final filePath in review.imageUrls!) {
        final file = File(filePath);

        try {
          // Upload to Cloudinary
          final imageUrl = await uploadImageToCloudinary(file);
          uploadedImageUrls.add(imageUrl);
        } catch (e) {
          print("Error uploading image to Cloudinary: $e");
        }
      }
    }

    print("uploaded image url : ${uploadedImageUrls}");

    final reviewData = {
      'userId': review.userId,
      'userName': review.userName,
      'serviceProviderId': review.serviceProviderId,
      'reviewText': review.reviewText,
      'ratings': review.ratings,
      'isVerified': review.isVerified,
      'createdAt': review.createdAt,
    };

    if (uploadedImageUrls.isNotEmpty) {
      reviewData['imageUrls'] = uploadedImageUrls;
    }

    try {
      final docRef = await firestore.collection('reviews').add(reviewData);
      final reviewId = docRef.id;

      final userRef = firestore.collection('users').doc(review.userId);
      await userRef.update({
        'reviewIds': FieldValue.arrayUnion([reviewId]),
      });
    } catch (e) {
      print("Error saving review to Firestore: $e");
    }
  }
}
