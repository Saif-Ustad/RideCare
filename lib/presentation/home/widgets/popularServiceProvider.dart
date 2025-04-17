import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ridecare/domain/entities/service_provider_entity.dart';
import 'package:ridecare/presentation/home/bloc/serviceProvider/service_provider_bloc.dart';
import 'package:ridecare/presentation/home/bloc/serviceProvider/service_provider_state.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../bookmark/bloc/bookmark_bloc.dart';
import '../../bookmark/bloc/bookmark_event.dart';
import '../../bookmark/bloc/bookmark_state.dart';

class PopularServiceProviderSection extends StatelessWidget {
  const PopularServiceProviderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSectionHeader(context, "Popular Services Provider"),
        const SizedBox(height: 10),
        _ServiceProviderList(),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: _textStyle(16, FontWeight.w600, AppColors.black)),
          GestureDetector(
            onTap: () {
              context.push('/popular-service-providers');
            },
            child: Text(
              "See All",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
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
      builder: (context, serviceProviderState) {
        if (serviceProviderState is ServiceProviderLoaded) {
          return BlocBuilder<BookmarkBloc, BookmarkState>(
            builder: (context, bookmarkState) {
              List<String> bookmarkedIds = [];

              if (bookmarkState is BookmarkLoaded) {
                bookmarkedIds =
                    bookmarkState.bookmarkedServiceProviders
                        .map((e) => e.id)
                        .toList();
              }

              return CarouselSlider(
                options: CarouselOptions(
                  height: 220,
                  autoPlay: false,
                  enlargeCenterPage: false,
                  viewportFraction: 0.7,
                  enableInfiniteScroll: true,
                ),
                items:
                    serviceProviderState.serviceProviders.map((provider) {
                      final isBookmarked = bookmarkedIds.contains(provider.id);
                      return _ServiceProviderCard(
                        provider: provider,
                        isBookmarked: isBookmarked,
                      );
                    }).toList(),
              );
            },
          );
        } else if (serviceProviderState is ServiceProviderLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (serviceProviderState is ServiceProviderError) {
          return Center(child: Text(serviceProviderState.message));
        } else {
          return const SizedBox(); // fallback
        }
      },
    );
  }
}

class _ServiceProviderCard extends StatelessWidget {
  final ServiceProviderEntity provider;
  final bool isBookmarked;

  const _ServiceProviderCard({
    required this.provider,
    super.key,
    required this.isBookmarked,
  });

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
              _buildImage(context),
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

  Widget _buildImage(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
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
          _buildBadge(
            Icons.star_rounded,
            provider.rating.toString(),
            AppColors.golden,
          ),
          _buildBadge(
            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            "",
            AppColors.primary,
            right: true,
            onTap: () {
              if (userId != null) {
                context.read<BookmarkBloc>().add(
                  ToggleBookmarkedServiceProviders(
                    userId: userId,
                    serviceProvider: provider,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(
    IconData icon,
    String text,
    Color color, {
    bool right = false,
    VoidCallback? onTap,
  }) {
    return Positioned(
      top: 8,
      left: right ? null : 8,
      right: right ? 8 : null,
      child: GestureDetector(
        onTap: onTap,
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
