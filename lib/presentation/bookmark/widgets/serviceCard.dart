import 'package:flutter/material.dart';
import 'package:ridecare/presentation/bookmark/widgets/serviceModel.dart';

import '../../../core/configs/theme/app_colors.dart';

class ServiceCard extends StatelessWidget {
  final ServiceModel service;

  const ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Card(
          color: AppColors.lightGray,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        service.imageUrl,
                        height: 100,
                        width: 140,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      left: 6,
                      top: 6,
                      child: buildRatingBadge(service.rating),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.serviceName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          buildInfoRow(Icons.location_on, service.distance),
                          const SizedBox(width: 12),
                          buildInfoRow(Icons.access_time_filled, service.time),
                        ],
                      ),

                      const SizedBox(height: 4),
                      buildPriceText(service.priceRange),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: -5,
          top: -10,
          child: Container(
            height: 35,
            width: 35,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.bookmark, color: Colors.purple, size: 22),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildRatingBadge(double rating) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Row(
      children: [
        Icon(Icons.star, color: AppColors.golden, size: 16),
        const SizedBox(width: 4),
        Text(
          rating.toString(),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );

  Widget buildInfoRow(IconData icon, String text) => Padding(
    padding: const EdgeInsets.only(top: 4),
    child: Row(
      children: [
        Icon(icon, color: AppColors.primary.withOpacity(0.8), size: 12),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: AppColors.darkGrey, fontSize: 12)),
      ],
    ),
  );

  Widget buildPriceText(String priceRange) => Row(
    children: [
      const Text(
        "Rs. ",
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      Text(
        priceRange,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      const Text(
        " / Service",
        style: TextStyle(
          color: AppColors.darkGrey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    ],
  );
}
