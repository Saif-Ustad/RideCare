import 'package:flutter/material.dart';
import 'package:ridecare/core/configs/assets/app_images.dart';

import '../../../core/configs/theme/app_colors.dart';

class ReviewTab extends StatelessWidget {
  final List<Map<String, dynamic>> reviews = [
    {
      "name": "Saif Ustad",
      "profilePic": AppImages.profilePhoto1,
      "timeAgo": "9 months ago",
    },
    {
      "name": "Prajwal Mahajan",
      "profilePic": AppImages.profilePhoto2,
      "timeAgo": "11 months ago",
    },
  ];

  ReviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reviews Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Reviews",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.edit, size: 16, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(
                    "add review",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Search Bar
          SizedBox(
            height: 40,
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: AppColors.primary),
                hintText: "Search in reviews",
                hintStyle: const TextStyle(fontSize: 12, color: AppColors.darkGrey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0), // Centers text
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.darkGrey, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterButton("Filter", Icons.filter_list, isIcon: true),
                _filterButton("Verified", null, isSelected: true),
                _filterButton("Latest", null, isSelected: true),
                _filterButton("With Photos", null, isDisabled: true),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Review List
          Column(
            children: reviews.map((review) => _reviewItem(review)).toList(),
          ),
        ],
      ),
    );
  }

  // Filter Button Widget
  Widget _filterButton(
    String text,
    IconData? icon, {
    bool isSelected = false,
    bool isDisabled = false,
    bool isIcon = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: isDisabled ? null : () {},
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          backgroundColor:
              isDisabled
                  ? AppColors.lightGray
                  : isSelected
                  ? AppColors.primary
                  : Colors.white,
          foregroundColor:
              isDisabled
                  ? AppColors.lightGray
                  : isSelected
                  ? Colors.white
                  : AppColors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side:
                isSelected
                    ? BorderSide.none
                    : BorderSide(color: AppColors.grey),
          ),
        ),
        child:
            isIcon
                ? Row(
                  children: [
                    Icon(icon, size: 16, color: Colors.black),
                    const SizedBox(width: 4),
                    Text(text),
                  ],
                )
                : Text(text),
      ),
    );
  }

  // Review Item Widget
  Widget _reviewItem(Map<String, dynamic> review) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(review["profilePic"]),
        radius: 20,
      ),
      title: Text(
        review["name"],
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      trailing: Text(
        review["timeAgo"],
        style: TextStyle(fontSize: 12, color: AppColors.darkGrey),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 6),
    );
  }
}
