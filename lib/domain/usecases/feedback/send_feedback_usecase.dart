import 'package:ridecare/domain/entities/feedback_entity.dart';
import 'package:ridecare/domain/repositories/feedback_repository.dart';

class SendFeedbackUseCase {
  final FeedbackRepository repository;

  SendFeedbackUseCase({ required this.repository});

  Future<void> call(FeedbackEntity feedback) async {
    return await repository.sendFeedback(feedback);
  }
}
