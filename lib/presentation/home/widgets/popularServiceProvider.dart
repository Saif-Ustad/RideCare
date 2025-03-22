import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';

class PopularServiceProviderSection extends StatelessWidget {
  PopularServiceProviderSection({super.key});

  final List<String> carouselImages = [
    AppImages.popularServiceProvider1,
    AppImages.popularServiceProvider2,
    AppImages.popularServiceProvider3,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSectionHeader("Popular Services Provider"),
        SizedBox(height: 10),
        CarouselSlider(
          options: CarouselOptions(
            height: 160,
            autoPlay: false,
            enlargeCenterPage: false,
            viewportFraction: 0.75,
            enableInfiniteScroll: true,
          ),
          items:
              carouselImages.map((item) {
                return Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage(item),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // ratings Badge
                    Positioned(
                      top: 15,
                      left: 15,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: AppColors.golden,
                              size: 16,
                            ),
                            SizedBox(width: 3),
                            Text(
                              "4.8",
                              style: TextStyle(
                                fontSize: 10,
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
                      top: 15,
                      right: 15,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Icon(
                          Icons.bookmark,
                          color: AppColors.primary,
                          size: 18,
                        ),
                      ),
                    ),

                    // View Button
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "View ->",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
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
      ),
    );
  }
}
