import 'package:ridecare/domain/entities/feedback_entity.dart';
import 'package:ridecare/domain/repositories/feedback_repository.dart';

class GetFeedbackByUserUseCase {
  final FeedbackRepository repository;

  GetFeedbackByUserUseCase({ required this.repository});

  Future<FeedbackEntity?> call(String userId) async {
    return await repository.getFeedbackByUser(userId);
  }
}
