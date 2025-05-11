import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ridecare/domain/entities/feedback_entity.dart';

class FeedbackModel extends FeedbackEntity {
  final String? id;

  FeedbackModel({
    this.id,
    required super.userId,
    required super.userName,
    required super.message,
    required super.rating,
    super.timestamp,
    required super.isVerified,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return FeedbackModel(
      id: id,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      message: json['message'] as String,
      rating: (json['rating'] as num).toDouble(),
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      isVerified: json['isVerified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'message': message,
      'rating': rating,
      'timestamp': Timestamp.fromDate(timestamp!),
      'isVerified': isVerified,
    };
  }

  FeedbackModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? message,
    double? rating,
    DateTime? timestamp,
    bool? isVerified,
  }) {
    return FeedbackModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      message: message ?? this.message,
      rating: rating ?? this.rating,
      timestamp: timestamp ?? this.timestamp,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  factory FeedbackModel.fromEntity(FeedbackEntity entity, {String? id}) {
    return FeedbackModel(
      id: id,
      userId: entity.userId,
      userName: entity.userName,
      message: entity.message,
      rating: entity.rating,
      timestamp: entity.timestamp,
      isVerified: entity.isVerified,
    );
  }
}
