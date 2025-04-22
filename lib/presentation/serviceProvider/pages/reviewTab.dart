import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ridecare/core/configs/theme/app_colors.dart';
import 'package:ridecare/presentation/home/bloc/user/user_bloc.dart';
import 'package:ridecare/presentation/home/bloc/user/user_state.dart';
import '../../../domain/entities/review_entity.dart';
import '../bloc/reviews/review_bloc.dart';
import '../bloc/reviews/review_event.dart';
import '../bloc/reviews/review_state.dart';
import '../widgets/reviewBottomSheet.dart';

class ReviewTab extends StatefulWidget {
  final String serviceProviderId;

  const ReviewTab({super.key, required this.serviceProviderId});

  @override
  State<ReviewTab> createState() => _ReviewTabState();
}

class _ReviewTabState extends State<ReviewTab>
    with AutomaticKeepAliveClientMixin {
  Set<String> _activeFilters = {};
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    context.read<ReviewBloc>().add(LoadReviews(widget.serviceProviderId));
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ReviewBloc, ReviewState>(
      builder: (context, state) {
        if (state is ReviewLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ReviewLoaded) {
          final reviews = state.reviews;

          // ✅ To trigger rebuild when filters change
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _activeFilters = state.activeFilters;
            });
          });

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
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
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          isScrollControlled: true,
                          builder:
                              (context) => ReviewBottomSheet(
                                serviceProviderId: widget.serviceProviderId,
                              ),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 16, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            "Add Review",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                SizedBox(
                  height: 40,
                  child: TextField(
                    onChanged: (query) {
                      context.read<ReviewBloc>().add(SearchReviews(query));
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: AppColors.primary),
                      hintText: "Search in reviews",
                      hintStyle: const TextStyle(
                        fontSize: 12,
                        color: AppColors.darkGrey,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.darkGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Filter buttons
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _filterButton(
                        "Filter",
                        Icons.filter_list,
                        onTap: () {
                          setState(() {
                            _showFilters = !_showFilters;
                          });
                        },
                      ),
                      if (_showFilters) ...[
                        _filterButton(
                          "Verified",
                          null,
                          onTap: () {
                            context.read<ReviewBloc>().add(
                              FilterReviewsByVerified(),
                            );
                          },
                        ),
                        _filterButton(
                          "Latest",
                          null,
                          onTap: () {
                            context.read<ReviewBloc>().add(
                              SortReviewsByLatest(),
                            );
                          },
                        ),

                        _filterButton(
                          "With Photos",
                          null,
                          onTap: () {
                            context.read<ReviewBloc>().add(
                              FilterReviewsWithPhotos(),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Review list
                reviews.isEmpty
                    ? const Center(child: Text('No reviews available.'))
                    : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: reviews.length,
                      itemBuilder:
                          (context, index) => _reviewItem(reviews[index]),
                    ),
              ],
            ),
          );
        } else if (state is ReviewError) {
          return Center(child: Text(state.message));
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _filterButton(
    String key,
    IconData? icon, {
    required VoidCallback onTap,
  }) {
    final bool isSelected = _activeFilters.contains(key);

    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          backgroundColor: isSelected ? AppColors.primary : Colors.white,
          foregroundColor: isSelected ? Colors.white : AppColors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected ? AppColors.primary : AppColors.grey,
            ),
          ),
        ),
        child:
            icon != null
                ? Row(
                  children: [
                    Icon(
                      icon,
                      size: 16,
                      color: isSelected ? Colors.white : AppColors.black,
                    ),
                    const SizedBox(width: 4),
                    Text(key),
                  ],
                )
                : Text(key),
      ),
    );
  }

  Widget _reviewItem(ReviewEntity review) {
    bool isCurrentUserReview = false;
    final userState = context.read<UserBloc>().state;
    if (userState is UserLoaded) {
      isCurrentUserReview = review.userId == userState.user.uid;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Image
          CircleAvatar(
            radius: 22,
            backgroundImage:
                review.userProfileImageUrl != null &&
                        review.userProfileImageUrl!.isNotEmpty
                    ? CachedNetworkImageProvider(review.userProfileImageUrl!)
                    : null,
            backgroundColor: Colors.grey.shade400,
            child:
                (review.userProfileImageUrl == null ||
                        review.userProfileImageUrl!.isEmpty)
                    ? Text(
                      review.userName.isNotEmpty
                          ? review.userName[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                    : null,
          ),

          const SizedBox(width: 12),

          // Review Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + Stars + Local Guide
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            review.userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 6),
                          _buildStarRating(review.ratings),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
                    if (isCurrentUserReview)
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: PopupMenuTheme(
                          data: const PopupMenuThemeData(color: Colors.white),
                          child: PopupMenuButton<String>(
                            padding: EdgeInsets.zero,
                            // removes default padding
                            icon: const Icon(
                              Icons.more_vert,
                              color: AppColors.darkGrey,
                              size: 22,
                            ),
                            onSelected: (value) {
                              if (value == 'delete') {
                                context.read<ReviewBloc>().add(
                                  DeleteReview(review.id!),
                                );
                              }
                            },
                            itemBuilder:
                                (BuildContext context) => [
                                  const PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                          size: 18,
                                        ),
                                        SizedBox(width: 8),
                                        Text('Delete'),
                                      ],
                                    ),
                                  ),
                                ],
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 2),

                // Time + Verified
                Row(
                  children: [
                    Text(
                      DateFormat.yMMMd().format(review.createdAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.darkGrey,
                      ),
                    ),
                    if (review.isVerified) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.verified, size: 14, color: Colors.green),
                      const SizedBox(width: 2),
                      const Text(
                        "Verified",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 6),

                // Review Text
                Text(
                  review.reviewText,
                  style: const TextStyle(fontSize: 13.5, height: 1.4),
                ),

                // Optional: Show review images or thumbs up
                if (review.imageUrls != null &&
                    review.imageUrls!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 80,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: review.imageUrls!.length,
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: review.imageUrls![index],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey.shade300,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                            errorWidget:
                                (context, url, error) => Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey.shade200,
                                  child: const Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                  ),
                                ),
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    const maxStars = 5;
    List<Widget> stars = [];

    for (int i = 0; i < maxStars; i++) {
      if (i < rating.floor()) {
        stars.add(const Icon(Icons.star, size: 16, color: Colors.amber));
      } else if (i < rating && (rating - i) >= 0.5) {
        stars.add(const Icon(Icons.star_half, size: 16, color: Colors.amber));
      } else {
        stars.add(const Icon(Icons.star_border, size: 16, color: Colors.amber));
      }
    }

    return Row(mainAxisSize: MainAxisSize.min, children: stars);
  }
}
