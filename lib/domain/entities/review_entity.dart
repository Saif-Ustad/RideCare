class ReviewEntity {
  final String id;
  final String userId;
  final String userName;
  final String? userProfileImageUrl;
  final String serviceProviderId;
  final String reviewText;
  final double ratings;
  final bool isVerified;
  final List<String> imageUrls;
  final DateTime createdAt;

  const ReviewEntity ({
    required this.id,
    required this.userId,
    required this.userName,
    this.userProfileImageUrl,
    required this.serviceProviderId,
    required this.reviewText,
    required this.ratings,
    required this.isVerified,
    required this.imageUrls,
    required this.createdAt,
  });
}
