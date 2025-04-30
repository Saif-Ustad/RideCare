import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ridecare/domain/entities/service_provider_entity.dart';

import '../../../core/configs/theme/app_colors.dart';

class ServiceProviderCard extends StatelessWidget {
  final ServiceProviderEntity provider;
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;

  const ServiceProviderCard({
    super.key,
    required this.provider,
    required this.isBookmarked,
    required this.onBookmarkToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/service-provider/${provider.id}');
      },
      child: Container(
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
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: provider.workImageUrl,
            height: 100,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder:
                (context, url) => Container(
                  height: 100,
                  width: double.infinity,
                  color: Colors.grey[300],
                ),
            errorWidget:
                (context, url, error) => Container(
                  height: 100,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, color: Colors.red),
                ),
            fadeInDuration: const Duration(milliseconds: 500),
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
                    provider.rating.toString(),
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
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onBookmarkToggle,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                  color: AppColors.primary,
                  size: 14,
                ),
              ),
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
            provider.name,
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
              Text( provider.distanceText ?? "- Km", style: TextStyle(color: AppColors.darkGrey)),
              SizedBox(width: 15),
              Icon(
                Icons.access_time_filled,
                color: AppColors.primary.withOpacity(0.8),
                size: 14,
              ),
              SizedBox(width: 5),
              Text( provider.durationText ?? "- Min", style: TextStyle(color: AppColors.darkGrey)),
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
                "${provider.serviceCharges.min} - ${provider.serviceCharges.max}",
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
