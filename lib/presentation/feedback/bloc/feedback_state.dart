import '../../../domain/entities/feedback_entity.dart';

abstract class FeedbackState {}

class FeedbackInitial extends FeedbackState {}

class FeedbackLoading extends FeedbackState {}

class FeedbackSuccess extends FeedbackState {}

class FeedbackLoaded extends FeedbackState {
  final FeedbackEntity feedback;

  FeedbackLoaded(this.feedback);
}

class FeedbackFailure extends FeedbackState {
  final String error;

  FeedbackFailure(this.error);
}

class FeedbackListLoaded extends FeedbackState {
  final List<FeedbackEntity> feedbacks;

  FeedbackListLoaded(this.feedbacks);
}
