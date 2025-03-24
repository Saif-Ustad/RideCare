import 'package:flutter/material.dart';

import '../../../core/configs/theme/app_colors.dart';

class ServiceProviderCard extends StatelessWidget {
  final String name;
  final String distance;
  final String time;
  final String price;
  final String image;

  const ServiceProviderCard({
    super.key,
    required this.name,
    required this.distance,
    required this.time,
    required this.price,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildImage(), _buildDetails()],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          Image.asset(
            image,
            height: 100,
            width: double.infinity,
            fit: BoxFit.cover,
          ),

          // ratings Badge
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Icon(Icons.star_rounded, color: AppColors.golden, size: 14),
                  SizedBox(width: 3),
                  Text(
                    "4.8",
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bookmark Button
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(Icons.bookmark, color: AppColors.primary, size: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: AppColors.primary.withOpacity(0.8),
                size: 14,
              ),
              SizedBox(width: 5),
              Text(distance, style: TextStyle(color: AppColors.darkGrey)),
              SizedBox(width: 15),
              Icon(
                Icons.access_time_filled,
                color: AppColors.primary.withOpacity(0.8),
                size: 14,
              ),
              SizedBox(width: 5),
              Text(time, style: TextStyle(color: AppColors.darkGrey)),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Text(
                "Rs. ",
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                price,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                " / Service",
                style: TextStyle(
                  color: AppColors.darkGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
