import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ridecare/presentation/auth/pages/signin.dart';
import 'package:ridecare/presentation/billing/pages/billSummary.dart';
import 'package:ridecare/presentation/billing/pages/eReceipt.dart';
import 'package:ridecare/presentation/billing/pages/paymentDone.dart';
import 'package:ridecare/presentation/billing/pages/paymentGetway.dart';
import 'package:ridecare/presentation/booking/pages/cancelBooking.dart';
import 'package:ridecare/presentation/booking/pages/myBookings.dart';
import 'package:ridecare/presentation/booking/pages/trackOrder.dart';
import 'package:ridecare/presentation/bookmark/pages/bookmark.dart';
import 'package:ridecare/presentation/chooseService/pages/chooseServices.dart';
import 'package:ridecare/presentation/home/pages/home.dart';
import 'package:ridecare/presentation/explore/pages/explore.dart';
import 'package:ridecare/presentation/location/pages/addLocation.dart';
import 'package:ridecare/presentation/location/pages/selectLocation.dart';
import 'package:ridecare/presentation/profile/pages/profile.dart';
import 'package:ridecare/presentation/serviceProvider/pages/appointmentBooking.dart';
import 'package:ridecare/presentation/serviceProvider/pages/serviceProviderDetails.dart';
import 'package:ridecare/presentation/splash/pages/splash.dart';
import '../../../common/helper/prefService.dart';
import '../../../presentation/auth/pages/form.dart';
import '../../../presentation/onboarding/pages/onboarding.dart';
import '../../../presentation/vehicles/pages/addVehicle.dart';
import '../../../presentation/vehicles/pages/selectVehicle.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splash',
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
    GoRoute(path: '/appointment-booking', builder: (context, state) =>  AppointmentBookingPage()),
    GoRoute(path: '/select-vehicle', builder: (context, state) => const SelectVehiclePage()),
    GoRoute(path: '/add-vehicle', builder: (context, state) => const AddVehiclePage()),
    GoRoute(path: '/select-location', builder: (context, state) => const SelectLocationPage()),
    GoRoute(path: '/add-location', builder: (context, state) => const AddLocationPage()),
    GoRoute(path: '/bill-summary/:id', builder: (context, state) => const BillSummaryPage()),
    GoRoute(path: '/payment-gateway', builder: (context, state) => const PaymentGatewayPage()),
    GoRoute(path: '/payment-done', builder: (context, state) => const PaymentDonePage()),
    GoRoute(path: '/e-receipt', builder: (context, state) => const EReceiptPage()),

    GoRoute(path: '/my-bookings', builder: (context, state) => const MyBookingsPage()),
    GoRoute(path: '/cancel-booking', builder: (context, state) => const CancelBookingPage()),
    GoRoute(path: '/track-order/:id', builder: (context, state) => const TrackOrderPage()),
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
