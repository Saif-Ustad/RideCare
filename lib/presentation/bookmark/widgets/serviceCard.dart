import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridecare/domain/entities/service_provider_entity.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../bloc/bookmark_bloc.dart';
import '../bloc/bookmark_event.dart';
import '../bloc/bookmark_state.dart';

class ServiceCard extends StatelessWidget {
  final ServiceProviderEntity serviceProvider;

  const ServiceCard({super.key, required this.serviceProvider});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

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
                      child: CachedNetworkImage(
                        imageUrl: serviceProvider.workImageUrl,
                        height: 100,
                        width: 130,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => Container(
                              height: 100,
                              width: 130,
                              color: Colors.grey[300],
                            ),
                        errorWidget:
                            (context, url, error) => Container(
                              height: 100,
                              width: 130,
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.broken_image,
                                color: Colors.red,
                              ),
                            ),
                        fadeInDuration: const Duration(milliseconds: 500),
                      ),
                    ),

                    Positioned(
                      left: 6,
                      top: 6,
                      child: buildRatingBadge(serviceProvider.rating),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        serviceProvider.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          buildInfoRow(Icons.location_on, "0.5 Km"),
                          const SizedBox(width: 12),
                          buildInfoRow(Icons.access_time_filled, "10 Min"),
                        ],
                      ),

                      const SizedBox(height: 5),
                      buildPriceText(
                        "${serviceProvider.serviceCharges.min} - ${serviceProvider.serviceCharges.max}",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        /// 🔖 Bookmark Toggle Button
        Positioned(
          right: -5,
          top: -10,
          child: GestureDetector(
            onTap: () {
              if (userId != null) {
                context.read<BookmarkBloc>().add(
                  ToggleBookmarkedServiceProviders(userId, serviceProvider.id),
                );
              }
            },
            child: BlocBuilder<BookmarkBloc, BookmarkState>(
              builder: (context, state) {
                bool isBookmarked = false;

                if (state is BookmarkLoaded) {
                  isBookmarked = state.bookmarkedServices.any(
                    (e) => e.id == serviceProvider.id,
                  );
                }

                return Container(
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
                  child: Center(
                    child: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                );
              },
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
        Icon(Icons.star, color: Colors.amber, size: 16),
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

  Widget buildPriceText(String priceRange) => Wrap(
    crossAxisAlignment: WrapCrossAlignment.center,
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
