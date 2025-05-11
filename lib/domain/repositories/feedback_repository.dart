import '../entities/feedback_entity.dart';

abstract class FeedbackRepository {
  Future<void> sendFeedback(FeedbackEntity feedback);
  Future<FeedbackEntity?> getFeedbackByUser(String userId);
  Future<void> updateFeedback(String feedbackId, FeedbackEntity updatedFeedback);
  Future<List<FeedbackEntity>> getLatestVerifiedFeedbacks();
}
