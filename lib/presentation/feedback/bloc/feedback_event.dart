import '../../../domain/entities/feedback_entity.dart';

abstract class FeedbackEvent {}

class SubmitFeedbackEvent extends FeedbackEvent {
  final FeedbackEntity feedback;

  SubmitFeedbackEvent(this.feedback);
}

class LoadFeedbackByUserEvent extends FeedbackEvent {
  final String userId;

  LoadFeedbackByUserEvent(this.userId);
}

class UpdateFeedbackEvent extends FeedbackEvent {
  final String feedbackId;
  final FeedbackEntity updatedFeedback;

  UpdateFeedbackEvent(this.feedbackId, this.updatedFeedback);
}


class FetchLatestVerifiedFeedbacks extends FeedbackEvent {}