import 'package:flutter/material.dart';
import 'package:ridecare/common/widgets/bottomNavigationBar/bottomNavigationBar.dart';
import 'package:ridecare/core/configs/theme/app_colors.dart';
import 'package:ridecare/presentation/home/widgets/HomeAppBar.dart';
import 'package:ridecare/presentation/home/widgets/chooseServices.dart';
import 'package:ridecare/presentation/home/widgets/popularServiceProvider.dart';
import 'package:ridecare/presentation/home/widgets/specialOfferCarousel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            slivers: [
              HomeAppBar(),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 15, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SpecialOfferSection(),
                      SizedBox(height: 20),
                      ChooseServicesSection(),
                      SizedBox(height: 20),
                      PopularServiceProviderSection(),
                      PopularServiceProviderSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBarSection(),
        ),
      ),
    );
  }
}
