import 'package:ridecare/domain/entities/feedback_entity.dart';
import 'package:ridecare/domain/repositories/feedback_repository.dart';
import '../datasources/feedback_remote_datasource.dart';
import '../models/feedback_model.dart';

class FeedbackRepositoryImpl implements FeedbackRepository {
  final FeedbackRemoteDataSource remoteDataSource;

  FeedbackRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> sendFeedback(FeedbackEntity feedback) async {
    return await remoteDataSource.sendFeedback(
      FeedbackModel.fromEntity(feedback),
    );
  }

  @override
  Future<FeedbackEntity?> getFeedbackByUser(String userId) async {
    return await remoteDataSource.getFeedbackByUser(userId);
  }

  @override
  Future<void> updateFeedback(
    String feedbackId,
    FeedbackEntity updatedFeedback,
  ) async {
    return await remoteDataSource.updateFeedback(
      feedbackId,
      FeedbackModel.fromEntity(updatedFeedback),
    );
  }

  @override
  Future<List<FeedbackEntity>> getLatestVerifiedFeedbacks() async {
    return await remoteDataSource.getLatestVerifiedFeedbacks();
  }
}
