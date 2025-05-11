import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/feedback_model.dart';

abstract class FeedbackRemoteDataSource {
  Future<void> sendFeedback(FeedbackModel feedback);

  Future<FeedbackModel?> getFeedbackByUser(String userId);

  Future<void> updateFeedback(String feedbackId, FeedbackModel updatedFeedback);

  Future<List<FeedbackModel>> getLatestVerifiedFeedbacks();
}

class FeedbackRemoteDataSourceImpl implements FeedbackRemoteDataSource {
  final FirebaseFirestore firestore;

  FeedbackRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> sendFeedback(FeedbackModel feedback) async {
    final existing = await getFeedbackByUser(feedback.userId);
    if (existing != null) {
      await updateFeedback(existing.id!, feedback);
    } else {
      await firestore.collection('feedbacks').add(feedback.toJson());
    }
  }

  @override
  Future<FeedbackModel?> getFeedbackByUser(String userId) async {
    final query =
        await firestore
            .collection('feedbacks')
            .where('userId', isEqualTo: userId)
            .limit(1)
            .get();

    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;
      return FeedbackModel.fromJson(doc.data()).copyWith(id: doc.id);
    }
    return null;
  }

  @override
  Future<void> updateFeedback(
    String feedbackId,
    FeedbackModel updatedFeedback,
  ) async {
    await firestore
        .collection('feedbacks')
        .doc(feedbackId)
        .update(updatedFeedback.toJson());
  }

  @override
  Future<List<FeedbackModel>> getLatestVerifiedFeedbacks() async {
    final querySnapshot =
        await firestore
            .collection('feedbacks')
            .where('isVerified', isEqualTo: true)
            .orderBy('timestamp', descending: true)
            .limit(3)
            .get();

    return querySnapshot.docs.map((doc) {
      return FeedbackModel.fromJson(doc.data(), id: doc.id);
    }).toList();
  }
}
