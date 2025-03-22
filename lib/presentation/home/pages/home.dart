import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ridecare/common/widgets/bottomNavigationBar/bottomNavigationBar.dart';
import 'package:ridecare/core/configs/theme/app_colors.dart';
import 'package:ridecare/presentation/home/widgets/HomeAppBar.dart';
import 'package:ridecare/presentation/home/widgets/chooseServices.dart';
import 'package:ridecare/presentation/home/widgets/popularServiceProvider.dart';
import 'package:ridecare/presentation/home/widgets/specialOfferCarousel.dart';
import '../widgets/exclusiveMembership.dart';
import '../widgets/recentBookings.dart';
import '../widgets/refer&Earn.dart';
import '../widgets/topReviewsAndRatings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isNavBarVisible = true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isNavBarVisible) {
          setState(() => _isNavBarVisible = false);
        }
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_isNavBarVisible) {
          setState(() => _isNavBarVisible = true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            controller: _scrollController,
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
                      SizedBox(height: 20),
                      RecentBookingsSection(),
                      SizedBox(height: 20),
                      MembershipBenefitsSection(),
                      SizedBox(height: 20),
                      ReferAndEarnSection(),
                      SizedBox(height: 20),
                      TopReviewsSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Animate BottomNavigationBar height smoothly
          bottomNavigationBar: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: _isNavBarVisible ? kBottomNavigationBarHeight : 0,
            // Animate height
            child: Wrap(
              children: [
                Opacity(
                  opacity: _isNavBarVisible ? 1.0 : 0.0, // Fade effect
                  child: BottomNavigationBarSection(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
