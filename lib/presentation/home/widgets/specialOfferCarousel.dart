import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridecare/core/configs/theme/app_colors.dart';

import '../../../core/configs/assets/app_images.dart';
import '../bloc/specialOffers/special_offer_bloc.dart';
import '../bloc/specialOffers/special_offer_event.dart';
import '../bloc/specialOffers/special_offer_state.dart';

class SpecialOfferSection extends StatefulWidget {
  const SpecialOfferSection({super.key});

  @override
  State<SpecialOfferSection> createState() => _SpecialOfferSectionState();
}

class _SpecialOfferSectionState extends State<SpecialOfferSection> {
  final List<String> carouselImages = [
    AppImages.specialOffer1,
    AppImages.specialOffer2,
    AppImages.specialOffer3,
  ];

  @override
  void initState() {
    super.initState();

    context.read<SpecialOfferBloc>().add(FetchSpecialOffers());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSectionHeader("#SpecialForYou"),
        SizedBox(height: 10),
        BlocBuilder<SpecialOfferBloc, SpecialOfferState>(
          builder: (context, state) {
            if (state is SpecialOfferLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SpecialOfferError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (state is SpecialOfferLoaded) {
              return CarouselSlider(
                options: CarouselOptions(
                  height: 150,
                  autoPlay: true,
                  enlargeCenterPage: false,
                  viewportFraction: 0.85,
                  enableInfiniteScroll: true,
                ),
                items:
                    state.offers.map((item) {
                      return Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: NetworkImage(item.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          // Limited Time Badge
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "Limited time!",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.black,
                                ),
                              ),
                            ),
                          ),

                          // Special Offer Text
                          Positioned(
                            top: 50,
                            left: 15,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Get Special Offer",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Row(
                                  children: [
                                    Text(
                                      "Up to ",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      item.discount,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Terms & Conditions
                          Positioned(
                            bottom: 15,
                            left: 15,
                            child: Text(
                              item.description,
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          // Claim Button
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.orange.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "Claim",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
              );
            }
            return const SizedBox.shrink();
          },
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
              fontSize: 16,
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
