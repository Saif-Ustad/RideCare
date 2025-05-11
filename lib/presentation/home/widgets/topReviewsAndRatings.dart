import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../feedback/bloc/feedback_bloc.dart';
import '../../feedback/bloc/feedback_state.dart';

class TopReviewsSection extends StatelessWidget {
  const TopReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("Customer Reviews"),
          const SizedBox(height: 10),
          BlocBuilder<FeedbackBloc, FeedbackState>(
            builder: (context, state) {
              if (state is FeedbackLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is FeedbackListLoaded) {
                final reviews = state.feedbacks;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return _buildReviewCard(
                      name: review.userName,
                      reviewText: review.message,
                      rating: review.rating.toInt(),
                    );
                  },
                );
              } else if (state is FeedbackFailure) {
                return Text("Error: ${state.error}");
              } else {
                return const Text("No reviews available.");
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard({
    required String name,
    required String reviewText,
    required int rating,
  }) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 15, top: 5),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                reviewText,
                style: const TextStyle(fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
        Positioned(right: 30, top: 0, child: _buildRatingStars(rating)),
      ],
    );
  }

  Widget _buildRatingStars(int rating) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: List.generate(
          rating,
          (index) => const Icon(Icons.star, color: Colors.white, size: 14),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        Text(
          "See All",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
