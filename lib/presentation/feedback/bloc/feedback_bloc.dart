import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridecare/domain/usecases/feedback/get_latest_verified_feedbacks_usecase.dart';
import '../../../domain/usecases/feedback/get_feedback_by_user_usecase.dart';
import '../../../domain/usecases/feedback/send_feedback_usecase.dart';
import '../../../domain/usecases/feedback/update_feedback_usecase.dart';
import 'feedback_event.dart';
import 'feedback_state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final SendFeedbackUseCase sendFeedbackUseCase;
  final GetFeedbackByUserUseCase getFeedbackByUserUseCase;
  final UpdateFeedbackUseCase updateFeedbackUseCase;
  final GetLatestVerifiedFeedbacksUseCase getLatestVerifiedFeedbacksUseCase;

  FeedbackBloc({
    required this.sendFeedbackUseCase,
    required this.getFeedbackByUserUseCase,
    required this.updateFeedbackUseCase,
    required this.getLatestVerifiedFeedbacksUseCase,
  }) : super(FeedbackInitial()) {
    on<SubmitFeedbackEvent>(_onSubmitFeedback);
    on<LoadFeedbackByUserEvent>(_onLoadFeedback);
    on<UpdateFeedbackEvent>(_onUpdateFeedback);
    on<FetchLatestVerifiedFeedbacks>(_onLoadLatestVerifiedFeedbacks);
  }

  Future<void> _onSubmitFeedback(
    SubmitFeedbackEvent event,
    Emitter<FeedbackState> emit,
  ) async {
    emit(FeedbackLoading());
    try {
      await sendFeedbackUseCase(event.feedback);
      emit(FeedbackSuccess());
    } catch (e) {
      emit(FeedbackFailure(e.toString()));
    }
  }

  Future<void> _onLoadFeedback(
    LoadFeedbackByUserEvent event,
    Emitter<FeedbackState> emit,
  ) async {
    emit(FeedbackLoading());
    try {
      final feedback = await getFeedbackByUserUseCase(event.userId);
      if (feedback != null) {
        emit(FeedbackLoaded(feedback));
      } else {
        emit(FeedbackFailure("No feedback found"));
      }
    } catch (e) {
      emit(FeedbackFailure(e.toString()));
    }
  }

  Future<void> _onUpdateFeedback(
    UpdateFeedbackEvent event,
    Emitter<FeedbackState> emit,
  ) async {
    emit(FeedbackLoading());
    try {
      await updateFeedbackUseCase(event.feedbackId, event.updatedFeedback);
      emit(FeedbackSuccess());
    } catch (e) {
      emit(FeedbackFailure(e.toString()));
    }
  }

  Future<void> _onLoadLatestVerifiedFeedbacks(
    FetchLatestVerifiedFeedbacks event,
    Emitter<FeedbackState> emit,
  ) async {
    emit(FeedbackLoading());
    try {
      final feedbacks = await getLatestVerifiedFeedbacksUseCase();
      emit(FeedbackListLoaded(feedbacks));
    } catch (e) {
      emit(FeedbackFailure(e.toString()));
    }
  }
}
