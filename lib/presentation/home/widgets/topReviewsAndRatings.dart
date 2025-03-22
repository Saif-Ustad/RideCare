import 'package:flutter/material.dart';

import '../../../core/configs/theme/app_colors.dart';

class TopReviewsSection extends StatelessWidget {
  final List<Map<String, String>> reviews = [
    {
      "name": "Alice",
      "review": "Fantastic service! Definitely my go-to.",
      "rating": "5",
    },
    {
      "name": "Bob",
      "review": "Good experience but pricing could be better.",
      "rating": "4",
    },
    {
      "name": "Charlie",
      "review": "Very professional, will use again.",
      "rating": "5",
    },
  ];

  TopReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("Customer Reviews"),
          SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return _buildReviewCard(review);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, String> review) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 15, top: 5),
          padding: EdgeInsets.all(16),
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
                review["name"]!,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4),
              Text(
                review["review"]!,
                style: TextStyle(fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
        Positioned(
          right: 30,
          top: 0,
          child: _buildRatingStars(int.parse(review["rating"]!)),
        ),
      ],
    );
  }

  Widget _buildRatingStars(int rating) {
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: List.generate(
          rating,
          (index) => Icon(Icons.star, color: Colors.white, size: 14),
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
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        Text(
          "See All",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
