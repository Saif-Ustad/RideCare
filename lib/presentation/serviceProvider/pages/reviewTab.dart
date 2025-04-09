// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ridecare/domain/entities/review_entity.dart';
//
// import '../../../core/configs/theme/app_colors.dart';
// import '../bloc/reviews/review_bloc.dart';
// import '../bloc/reviews/review_state.dart';
//
// class ReviewTab extends StatelessWidget {
//   // final List<Map<String, dynamic>> reviews = [
//   //   {
//   //     "name": "Saif Ustad",
//   //     "profilePic": AppImages.profilePhoto1,
//   //     "timeAgo": "9 months ago",
//   //   },
//   //   {
//   //     "name": "Prajwal Mahajan",
//   //     "profilePic": AppImages.profilePhoto2,
//   //     "timeAgo": "11 months ago",
//   //   },
//   // ];
//
//   const ReviewTab({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ReviewBloc, ReviewState>(
//       builder: (context, state) {
//         if (state is ReviewLoading) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (state is ReviewLoaded) {
//           final reviews = state.reviews;
//
//           if (reviews.isEmpty) {
//             return const Center(child: Text('No services available.'));
//           }
//
//           return SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Reviews Header
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       "Reviews",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                         color: AppColors.black,
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         Icon(Icons.edit, size: 16, color: AppColors.primary),
//                         const SizedBox(width: 4),
//                         Text(
//                           "add review",
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                             color: AppColors.primary,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//
//                 // Search Bar
//                 SizedBox(
//                   height: 40,
//                   child: TextField(
//                     decoration: InputDecoration(
//                       prefixIcon: Icon(Icons.search, color: AppColors.primary),
//                       hintText: "Search in reviews",
//                       hintStyle: const TextStyle(
//                         fontSize: 12,
//                         color: AppColors.darkGrey,
//                       ),
//                       filled: true,
//                       fillColor: Colors.white,
//                       contentPadding: const EdgeInsets.symmetric(vertical: 0),
//                       // Centers text
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide.none,
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide(
//                           color: AppColors.darkGrey,
//                           width: 1,
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide(
//                           color: AppColors.primary,
//                           width: 1.5,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 12),
//
//                 SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     children: [
//                       _filterButton("Filter", Icons.filter_list, isIcon: true),
//                       _filterButton("Verified", null, isSelected: true),
//                       _filterButton("Latest", null, isSelected: true),
//                       _filterButton("With Photos", null, isDisabled: true),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 12),
//
//                 // Review List
//                 Column(
//                   children:
//                       reviews.map((review) => _reviewItem(review)).toList(),
//                 ),
//               ],
//             ),
//           );
//         } else if (state is ReviewError) {
//           return Center(child: Text(state.message));
//         } else {
//           return const SizedBox();
//         }
//       },
//     );
//   }
//
//   // Filter Button Widget
//   Widget _filterButton(
//     String text,
//     IconData? icon, {
//     bool isSelected = false,
//     bool isDisabled = false,
//     bool isIcon = false,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(right: 8),
//       child: ElevatedButton(
//         onPressed: isDisabled ? null : () {},
//         style: ElevatedButton.styleFrom(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           backgroundColor:
//               isDisabled
//                   ? AppColors.lightGray
//                   : isSelected
//                   ? AppColors.primary
//                   : Colors.white,
//           foregroundColor:
//               isDisabled
//                   ? AppColors.lightGray
//                   : isSelected
//                   ? Colors.white
//                   : AppColors.black,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//             side:
//                 isSelected
//                     ? BorderSide.none
//                     : BorderSide(color: AppColors.grey),
//           ),
//         ),
//         child:
//             isIcon
//                 ? Row(
//                   children: [
//                     Icon(icon, size: 16, color: Colors.black),
//                     const SizedBox(width: 4),
//                     Text(text),
//                   ],
//                 )
//                 : Text(text),
//       ),
//     );
//   }
//
//   // Review Item Widget
//   Widget _reviewItem(ReviewEntity review) {
//     return ListTile(
//       leading: CircleAvatar(
//         backgroundImage: AssetImage(review.imageUrls[0]),
//         radius: 20,
//       ),
//       title: Text(
//         review["name"],
//         style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//       ),
//       trailing: Text(
//         review.createdAt as String,
//         style: TextStyle(fontSize: 12, color: AppColors.darkGrey),
//       ),
//       contentPadding: const EdgeInsets.symmetric(vertical: 6),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ridecare/core/configs/theme/app_colors.dart';
import '../../../domain/entities/review_entity.dart';
import '../bloc/reviews/review_bloc.dart';
import '../bloc/reviews/review_event.dart';
import '../bloc/reviews/review_state.dart';

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
                    Row(
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
                  ],
                ),
                const SizedBox(height: 12),

                // Search bar (no logic implemented here)
                SizedBox(
                  height: 40,
                  child: TextField(
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

  // Review Item Widget
  Widget _reviewItem(ReviewEntity review) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundImage: AssetImage("assets/images/profile1.png"),
        radius: 20,
      ),
      title: Text(
        review.userName,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(review.reviewText),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.star, size: 16, color: Colors.orange),
              Text('${review.ratings} / 5'),
            ],
          ),
        ],
      ),
      trailing: Text(
        DateFormat.yMMMd().format(review.createdAt),
        style: const TextStyle(fontSize: 12, color: AppColors.darkGrey),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 6),
    );
  }
}
