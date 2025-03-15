import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridecare/core/configs/assets/app_vectors.dart';
import 'package:ridecare/core/configs/theme/app_colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../common/widgets/button/squareButton.dart';
import '../../auth/pages/signin.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';
import '../widgets/onboarding_banner.dart';

class OnboardingPage extends StatelessWidget {
  OnboardingPage({super.key});

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Stack(
          children: [
          PageView(
          controller: _pageController,
          onPageChanged: (index) {
            context.read<OnboardingBloc>().add(PageChanged(index));
          },

          children: const [
            OnBoardingBanner(
              image: AppVectors.onboarding1,
              title: "Welcome to RideCare",
              subtitle:
              "Book repairs, track service history, and manage your car with ease",
            ),
            OnBoardingBanner(
              image: AppVectors.onboarding2,
              title: "Book Your Service in Few Steps",
              subtitle:
              "Select your vehicle, choose services, and schedule as appointment.",
            ),
            OnBoardingBanner(
              image: AppVectors.onboarding3,
              title: "Stay Updated!",
              subtitle:
              "Get real-time status updates, service completion alerts, and estimated time",
            ),
          ],
        ),

        // SmoothPageIndicator
        Positioned(
        bottom: 100,
        left: 0,
        right: 0,
        child: Center(
          child: SmoothPageIndicator(
            controller: _pageController,
            count: 3,
            effect: const ExpandingDotsEffect(
              activeDotColor: AppColors.primary,
              dotHeight: 8,
              dotWidth: 8,
            ),
          ),
        ),
      ),

      // Square Button
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Center(
          child: BlocBuilder<OnboardingBloc, OnboardingState>(
            builder: (context, state) {
              return SquareButton(
                onPressed: () {
                  if (state.currentPage < 2) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignInPage()),
                    );
                  }
                },
                buttonText:
                state.currentPage == 2 ? "Get Started" : "Next",
              );
            },
          ),
        ),
      ),
      ],
    ),)
    ,
    );
  }
}
