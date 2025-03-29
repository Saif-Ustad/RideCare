import 'package:flutter/material.dart';
import 'package:ridecare/core/configs/assets/app_images.dart';
import 'package:ridecare/core/configs/theme/app_colors.dart';

class GalleryTab extends StatelessWidget {
  final List<String> galleryImages = [
    AppImages.galleryImage1,
    AppImages.galleryImage2,
    AppImages.galleryImage1,
    AppImages.galleryImage2,
    AppImages.galleryImage1,
    AppImages.galleryImage2,
  ];

  GalleryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gallery Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: "Gallery ",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "(${galleryImages.length})",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "View All",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // GridView for Gallery Images
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1, // Adjust for square images
              ),
              itemCount: galleryImages.length,
              itemBuilder: (context, index) {
                return _galleryItem(galleryImages[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget for Each Gallery Item
  Widget _galleryItem(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(imageUrl, fit: BoxFit.cover),
    );
  }
}
