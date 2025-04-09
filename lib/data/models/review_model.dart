import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ridecare/domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  ReviewModel({
    required super.id,
    required super.userId,
    required super.userName,
    super.userProfileImageUrl,
    required super.serviceProviderId,
    required super.reviewText,
    required super.ratings,
    required super.isVerified,
    required super.imageUrls,
    required super.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> reviewJson,Map<String, dynamic> userJson, String documentId) {
    return ReviewModel(
      id: documentId,
      userId: reviewJson['userId'],
      userName: '${userJson['firstName'] ?? ''} ${userJson['lastName'] ?? ''}'.trim(),
      userProfileImageUrl: userJson['profileImageUrl']?? "",
      serviceProviderId: reviewJson['serviceProviderId'],
      reviewText: reviewJson['reviewText'],
      ratings: (reviewJson['ratings'] as num).toDouble(),
      isVerified: reviewJson['isVerified'],
      imageUrls: List<String>.from(reviewJson['imageUrls']??  []),
      createdAt: (reviewJson['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'userProfileImageUrl': userProfileImageUrl,
      'serviceProviderId': serviceProviderId,
      'reviewText': reviewText,
      'ratings': ratings,
      'isVerified': isVerified,
      'imageUrls': imageUrls,
      'createdAt': createdAt,
    };
  }
}
