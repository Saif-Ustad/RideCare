import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ridecare/presentation/auth/pages/signin.dart';
import 'package:ridecare/presentation/bookmark/pages/bookmark.dart';
import 'package:ridecare/presentation/chooseService/pages/chooseServices.dart';
import 'package:ridecare/presentation/home/pages/home.dart';
import 'package:ridecare/presentation/explore/pages/explore.dart';
import 'package:ridecare/presentation/profile/pages/profile.dart';
import 'package:ridecare/presentation/serviceProvider/pages/serviceProviderDetails.dart';
import 'package:ridecare/presentation/splash/pages/splash.dart';
import '../../../common/helper/prefService.dart';
import '../../../presentation/auth/pages/form.dart';
import '../../../presentation/onboarding/pages/onboarding.dart';

final GoRouter router = GoRouter(
  initialLocation: '/choose-service',
  refreshListenable: AuthNotifier(),
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
    GoRoute(path: '/onboarding', builder: (context, state) => OnboardingPage()),

    GoRoute(path: '/signin', builder: (context, state) => const SignInPage()),
    GoRoute(path: '/userform', builder: (context, state) => const UserFormPage(),),

    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    GoRoute(path: '/explore', builder: (context, state) => const ExplorePage()),
    GoRoute(path: '/bookmark', builder: (context, state) =>  BookmarkPage()),
    GoRoute(path: '/profile', builder: (context, state) => const ProfilePage()),

    // GoRoute(path: '/service-provider/:id', builder: (context, state) =>  ServiceProviderDetailPage()),
    // Use a prebuilt transition
    GoRoute(
      path: '/service-provider/:id',
      pageBuilder: (context, state) {
        final String id = state.pathParameters['id']!;
        return MaterialPage(
          key: state.pageKey,
          child: ServiceProviderDetailPage(),
          fullscreenDialog: true, // Enables the default slide-up transition
        );
      },
    ),

    GoRoute(path: '/choose-service', builder: (context, state) => const ChooseServicesPage()),
  ],

  redirect: (context, state) async {
    bool hasSeenOnboarding = await PrefService.isOnboardingSeen();
    bool isLoggedIn = FirebaseAuth.instance.currentUser != null;

    if (state.uri.path == '/splash') {
      return null;
    }
    if (!hasSeenOnboarding) {
      return '/onboarding';
    } else if (!isLoggedIn) {
      return '/signin';
    }
    return null;
  },
);

class AuthNotifier extends ChangeNotifier {
  AuthNotifier() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      notifyListeners();
    });
  }
}
