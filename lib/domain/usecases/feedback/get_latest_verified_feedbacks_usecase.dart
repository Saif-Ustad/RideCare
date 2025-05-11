import 'package:ridecare/domain/entities/feedback_entity.dart';
import 'package:ridecare/domain/repositories/feedback_repository.dart';

class GetLatestVerifiedFeedbacksUseCase {
  final FeedbackRepository repository;

  GetLatestVerifiedFeedbacksUseCase({required this.repository});

  Future<List<FeedbackEntity>> call() async {
    return await repository.getLatestVerifiedFeedbacks();
  }
}
