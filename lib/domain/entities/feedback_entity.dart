class FeedbackEntity {
  final String? id;
  final String userId;
  final String userName;
  final String message;
  final double rating;
  final DateTime? timestamp;
  final bool isVerified;

  FeedbackEntity({
    this.id,
    required this.userId,
    required this.userName,
    required this.message,
    required this.rating,
    this.timestamp,
    required this.isVerified
  });
}
