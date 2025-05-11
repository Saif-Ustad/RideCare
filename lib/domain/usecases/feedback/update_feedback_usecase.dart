import 'package:ridecare/domain/entities/feedback_entity.dart';
import 'package:ridecare/domain/repositories/feedback_repository.dart';

class UpdateFeedbackUseCase {
  final FeedbackRepository repository;

  UpdateFeedbackUseCase({ required this.repository});

  Future<void> call(String feedbackId, FeedbackEntity updatedFeedback) async {
    return await repository.updateFeedback(feedbackId, updatedFeedback);
  }
}
