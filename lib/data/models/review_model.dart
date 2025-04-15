import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ridecare/domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  ReviewModel({
    super.id,
    required super.userId,
    required super.userName,
    super.userProfileImageUrl,
    required super.serviceProviderId,
    required super.reviewText,
    required super.ratings,
    required super.isVerified,
    super.imageUrls,
    required super.createdAt,
  });

  factory ReviewModel.fromJson(
    Map<String, dynamic> reviewJson,
    Map<String, dynamic> userJson,
    String documentId,
  ) {
    return ReviewModel(
      id: documentId,
      userId: reviewJson['userId'],
      userName:
          '${userJson['firstName'] ?? ''} ${userJson['lastName'] ?? ''}'.trim(),
      userProfileImageUrl: userJson['userProfileImageUrl'] ?? "",
      serviceProviderId: reviewJson['serviceProviderId'],
      reviewText: reviewJson['reviewText'],
      ratings: (reviewJson['ratings'] as num).toDouble(),
      isVerified: reviewJson['isVerified'],
      imageUrls:
          reviewJson['imageUrls'] != null
              ? List<String>.from(reviewJson['imageUrls'])
              : null,
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
      if (imageUrls != null) 'imageUrls': imageUrls,
      'createdAt': createdAt,
    };
  }

  factory ReviewModel.fromEntity(ReviewEntity entity) {
    return ReviewModel(
      id: entity.id,
      userId: entity.userId,
      userName: entity.userName,
      userProfileImageUrl: entity.userProfileImageUrl,
      serviceProviderId: entity.serviceProviderId,
      reviewText: entity.reviewText,
      ratings: entity.ratings,
      isVerified: entity.isVerified,
      imageUrls: entity.imageUrls,
      createdAt: entity.createdAt,
    );
  }
}
