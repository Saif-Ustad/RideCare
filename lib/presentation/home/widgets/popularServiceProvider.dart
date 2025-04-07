// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
//
// import '../../../core/configs/assets/app_images.dart';
// import '../../../core/configs/theme/app_colors.dart';
//
// class PopularServiceProviderSection extends StatelessWidget {
//   PopularServiceProviderSection({super.key});
//
//   final List<String> carouselImages = [
//     AppImages.popularServiceProvider1,
//     AppImages.popularServiceProvider2,
//     AppImages.popularServiceProvider3,
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         _buildSectionHeader("Popular Services Provider"),
//         SizedBox(height: 10),
//         CarouselSlider(
//           options: CarouselOptions(
//             height: 140,
//             autoPlay: false,
//             enlargeCenterPage: false,
//             viewportFraction: 0.65,
//             enableInfiniteScroll: true,
//           ),
//           items:
//               carouselImages.map((item) {
//                 return Stack(
//                   children: [
//                     Container(
//                       margin: EdgeInsets.all(5),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         image: DecorationImage(
//                           image: AssetImage(item),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     // ratings Badge
//                     Positioned(
//                       top: 15,
//                       left: 15,
//                       child: Container(
//                         padding: EdgeInsets.all(5),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.8),
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.star_rounded,
//                               color: AppColors.golden,
//                               size: 16,
//                             ),
//                             SizedBox(width: 3),
//                             Text(
//                               "4.8",
//                               style: TextStyle(
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w600,
//                                 color: AppColors.black,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//
//                     // Bookmark Button
//                     Positioned(
//                       top: 15,
//                       right: 15,
//                       child: Container(
//                         padding: EdgeInsets.all(5),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.8),
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Icon(
//                           Icons.bookmark,
//                           color: AppColors.primary,
//                           size: 18,
//                         ),
//                       ),
//                     ),
//
//                     // View Button
//                     Positioned(
//                       bottom: 10,
//                       right: 10,
//                       child: Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 8,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.6),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           "View ->",
//                           style: TextStyle(
//                             fontSize: 10,
//                             fontWeight: FontWeight.w500,
//                             color: AppColors.black,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               }).toList(),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSectionHeader(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 15),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: AppColors.black,
//             ),
//           ),
//           Text(
//             "See All",
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: AppColors.primary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ridecare/domain/entities/service_provider_entity.dart';
import 'package:ridecare/presentation/home/bloc/serviceProvider/service_provider_bloc.dart';
import 'package:ridecare/presentation/home/bloc/serviceProvider/service_provider_state.dart';
import '../../../core/configs/theme/app_colors.dart';

class PopularServiceProviderSection extends StatelessWidget {
  const PopularServiceProviderSection({super.key});

  // final List<ServiceProvider> serviceProviders = [
  //   ServiceProvider(
  //     "1",
  //     "Bajaj Service Center",
  //     "0.5 km",
  //     "2 Mins",
  //     "100-1200",
  //     AppImages.popularServiceProvider1,
  //   ),
  //   ServiceProvider(
  //     "1",
  //     "Honda Service Center",
  //     "1.5 km",
  //     "8 Mins",
  //     "200-1500",
  //     AppImages.popularServiceProvider2,
  //   ),
  //   ServiceProvider(
  //     "1",
  //     "Toyota Service Center",
  //     "0.5 km",
  //     "2 Mins",
  //     "500-2300",
  //     AppImages.popularServiceProvider3,
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSectionHeader("Popular Services Provider"),
        const SizedBox(height: 10),
        _ServiceProviderList(),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: _textStyle(16, FontWeight.w600, AppColors.black)),
          Text(
            "See All",
            style: _textStyle(14, FontWeight.w500, AppColors.primary),
          ),
        ],
      ),
    );
  }

  TextStyle _textStyle(double size, FontWeight weight, Color color) {
    return TextStyle(fontSize: size, fontWeight: weight, color: color);
  }
}

class _ServiceProviderList extends StatelessWidget {
  const _ServiceProviderList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceProviderBloc, ServiceProviderState>(
      builder: (context, state) {
        if (state is ServiceProviderLoaded) {
          return CarouselSlider(
            options: CarouselOptions(
              height: 220,
              autoPlay: false,
              enlargeCenterPage: false,
              viewportFraction: 0.7,
              enableInfiniteScroll: true,
            ),
            items:
                state.providers
                    .map((provider) => _ServiceProviderCard(provider: provider))
                    .toList(),
          );
        } else if (state is ServiceProviderLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ServiceProviderError) {
          return Center(child: Text(state.message));
        } else {
          return const SizedBox(); // or fallback UI
        }
      },
    );
  }
}

class _ServiceProviderCard extends StatelessWidget {
  final ServiceProviderEntity provider;

  const _ServiceProviderCard({required this.provider, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/service-provider/${provider.id}');
      },
      child: Container(
        // width: 210,
        margin: const EdgeInsets.all(8),
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
            children: [
              _buildImage(),
              const SizedBox(height: 8),
              Text(
                provider.name,
                style: _textStyle(14, FontWeight.w500, AppColors.black),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  _buildInfoRow(Icons.location_on, "0.5 Km"),
                  const SizedBox(width: 10),
                  _buildInfoRow(Icons.access_time_filled, "2 Mins"),
                ],
              ),
              const SizedBox(height: 5),
              _buildPrice(),
            ],
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
          Image.network(
            provider.workImageUrl,
            height: 100,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          _buildBadge(
            Icons.star_rounded,
            provider.rating.toString(),
            AppColors.golden,
          ),
          _buildBadge(Icons.bookmark, "", AppColors.primary, right: true),
        ],
      ),
    );
  }

  Widget _buildBadge(
    IconData icon,
    String text,
    Color color, {
    bool right = false,
  }) {
    return Positioned(
      top: 8,
      left: right ? null : 8,
      right: right ? 8 : null,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 16),
            if (text.isNotEmpty) const SizedBox(width: 3),
            if (text.isNotEmpty)
              Text(
                text,
                style: _textStyle(10, FontWeight.w600, AppColors.black),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary.withOpacity(0.8), size: 14),
        const SizedBox(width: 5),
        Text(text, style: TextStyle(color: AppColors.darkGrey)),
      ],
    );
  }

  Widget _buildPrice() {
    return Row(
      children: [
        Text("Rs. ", style: _textStyle(14, FontWeight.w600, AppColors.primary)),
        Text(
          "${provider.serviceCharges.min} - ${provider.serviceCharges.max}",
          style: _textStyle(14, FontWeight.w600, AppColors.primary),
        ),
        Text(
          " / Service",
          style: _textStyle(12, FontWeight.w400, AppColors.darkGrey),
        ),
      ],
    );
  }

  TextStyle _textStyle(double size, FontWeight weight, Color color) {
    return TextStyle(fontSize: size, fontWeight: weight, color: color);
  }
}
