import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/feedback_entity.dart';
import '../../home/bloc/user/user_bloc.dart';
import '../../home/bloc/user/user_state.dart';
import '../bloc/feedback_bloc.dart';
import '../bloc/feedback_event.dart';
import '../bloc/feedback_state.dart';
import '../../../core/configs/theme/app_colors.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();
  double _rating = 0.0;
  String? _existingFeedbackId;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final userState = context.read<UserBloc>().state;
    if (userState is UserLoaded && !_isEditing) {
      final feedbackState = context.read<FeedbackBloc>().state;
      if (feedbackState is! FeedbackLoaded) {
        context.read<FeedbackBloc>().add(
          LoadFeedbackByUserEvent(userState.user.uid),
        );
      } else {
        // Feedback already loaded, no need to reload
        _existingFeedbackId = feedbackState.feedback.id;
        _feedbackController.text = feedbackState.feedback.message;
        _rating = feedbackState.feedback.rating;
      }
    }
  }

  void _submitFeedback() {
    final feedbackText = _feedbackController.text.trim();
    if (feedbackText.isEmpty || _rating == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please provide feedback and a rating")),
      );
      return;
    }

    final userState = context.read<UserBloc>().state;
    if (userState is UserLoaded) {
      final user = userState.user;
      final feedback = FeedbackEntity(
        userId: user.uid,
        userName: user.firstName ?? 'Unknown',
        message: feedbackText,
        rating: _rating,
        isVerified: false,
      );

      if (_existingFeedbackId != null) {
        context.read<FeedbackBloc>().add(
          UpdateFeedbackEvent(_existingFeedbackId!, feedback),
        );
      } else {
        context.read<FeedbackBloc>().add(SubmitFeedbackEvent(feedback));
      }

      setState(() {
        _isEditing = false;
      });
    }
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Widget _buildRatingStars(double rating, {Function(int)? onRate}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            rating >= index + 1 ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 32,
          ),
          onPressed:
              onRate != null
                  ? () {
                    setState(() {
                      _rating = (index + 1).toDouble();
                    });
                  }
                  : null,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _buildLeadingIconButton(() => context.pop()),
        title: const Text(
          "Feedback",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocConsumer<FeedbackBloc, FeedbackState>(
          listener: (context, state) {
            if (state is FeedbackSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Feedback submitted successfully!"),
                ),
              );
            } else if (state is FeedbackFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Error: ${state.error}")));
            } else if (state is FeedbackLoaded) {
              _feedbackController.text = state.feedback.message;
              _rating = state.feedback.rating;
              _existingFeedbackId = state.feedback.id;
              setState(() {});
            }
          },
          builder: (context, state) {
            // Show a loading indicator while feedback is loading
            if (state is FeedbackLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (!_isEditing && _existingFeedbackId != null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Your Submitted Feedback",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    color: AppColors.lightGray,
                    // Set your desired color here
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRatingStars(_rating),
                          const SizedBox(height: 8),
                          Text(
                            _feedbackController.text,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton.icon(
                      icon: const Icon(
                        Icons.edit,
                        size: 18,
                        color: Colors.white,
                      ),
                      onPressed: () => setState(() => _isEditing = true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      label: const Text(
                        "Edit Feedback",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Your Rating",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  _buildRatingStars(_rating, onRate: (_) {}),
                  const SizedBox(height: 16),
                  const Text(
                    "Your Feedback",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _feedbackController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Write your feedback here...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              state is FeedbackLoading ? null : _submitFeedback,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child:
                              state is FeedbackLoading
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                  : const Text(
                                    "Submit",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (_existingFeedbackId != null)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => setState(() => _isEditing = false),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.lightGray,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text("Cancel"),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLeadingIconButton(VoidCallback onPressed) => Padding(
    padding: const EdgeInsets.only(left: 15),
    child: Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.darkGrey, width: 1),
        color: Colors.white,
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
        onPressed: onPressed,
        constraints: const BoxConstraints(),
        padding: EdgeInsets.zero,
      ),
    ),
  );
}
