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
import 'package:ridecare/presentation/helpCenter/pages/helpCenter.dart';
import 'package:ridecare/presentation/home/pages/home.dart';
import 'package:ridecare/presentation/explore/pages/explore.dart';
import 'package:ridecare/presentation/home/pages/notification.dart';
import 'package:ridecare/presentation/home/pages/popularServiceProvider.dart';
import 'package:ridecare/presentation/home/pages/specialOffers.dart';
import 'package:ridecare/presentation/location/pages/bookingPages/addLocationFromBooking.dart';
import 'package:ridecare/presentation/location/pages/bookingPages/selectLocationFromBooking.dart';
import 'package:ridecare/presentation/profile/pages/profile.dart';
import 'package:ridecare/presentation/profile/pages/yourProfile.dart';
import 'package:ridecare/presentation/serviceProvider/pages/appointmentBooking.dart';
import 'package:ridecare/presentation/serviceProvider/pages/serviceProviderDetails.dart';
import 'package:ridecare/presentation/splash/pages/splash.dart';
import 'package:ridecare/presentation/wallet/pages/addMoneyWallet.dart';
import '../../../common/helper/prefService.dart';
import '../../../presentation/auth/pages/form.dart';
import '../../../presentation/home/pages/chooseCategory.dart';
import '../../../presentation/location/pages/profilePages/addLocationFromProfile.dart';
import '../../../presentation/location/pages/profilePages/selectLocationFromProfile.dart';
import '../../../presentation/onboarding/pages/onboarding.dart';
import '../../../presentation/vehicles/pages/bookingPages/addVehicleFromBooking.dart';
import '../../../presentation/vehicles/pages/bookingPages/selectVehicleFromBooking.dart';
import '../../../presentation/vehicles/pages/profilePages/addVehicleFromProfile.dart';
import '../../../presentation/vehicles/pages/profilePages/selectVehicleFromProfile.dart';
import '../../../presentation/wallet/pages/wallet.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splash',
  refreshListenable: AuthNotifier(),
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
    GoRoute(path: '/onboarding', builder: (context, state) => OnboardingPage()),

    GoRoute(path: '/signin', builder: (context, state) => const SignInPage()),
    GoRoute(
      path: '/userform',
      builder: (context, state) => const UserFormPage(),
    ),

    GoRoute(path: '/home', builder: (context, state) => const HomePage()),

    GoRoute(path: '/special-offers', builder: (context, state) => const SpecialOffersPage()),
    GoRoute(path: '/popular-service-providers', builder: (context, state) => const PopularServiceProviderPage()),
    GoRoute(
      path: '/choose-category',
      builder: (context, state) {
        final categoryId = state.uri.queryParameters['category'] ?? 'repairs';
        return ChooseCategoryPage(categoryId: categoryId);
      },
    ),
    GoRoute(path: '/notification', builder: (context, state) => const NotificationPage()),



    GoRoute(path: '/explore', builder: (context, state) => const ExplorePage()),
    GoRoute(path: '/bookmark', builder: (context, state) => BookmarkPage()),

    GoRoute(path: '/profile', builder: (context, state) => const ProfilePage()),
    GoRoute(path: '/your-profile/:id', builder: (context, state) => const YourProfilePage()),
    GoRoute(path: '/wallet', builder: (context, state) => const WalletPage()),
    GoRoute(path: '/add-money-wallet', builder: (context, state) => const AddMoneyWalletPage()),
    GoRoute(path: '/help-center', builder: (context, state) => const HelpCenterPage()),


    GoRoute(
      path: '/service-provider/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ServiceProviderDetailPage(id: id);
      },
    ),

    GoRoute(
      path: '/choose-service',
      builder: (context, state) {
        final serviceProviderId =
            state.uri.queryParameters['serviceProviderId'];
        return ChooseServicesPage(serviceProviderId: serviceProviderId ?? '');
      },
    ),

    GoRoute(
      path: '/appointment-booking',
      builder: (context, state) {
        final serviceProviderId =
            state.uri.queryParameters['serviceProviderId'];
        return AppointmentBookingPage(
          serviceProviderId: serviceProviderId ?? '',
        );
      },
    ),
    GoRoute(
      path: '/select-vehicle-booking',
      builder: (context, state) => const SelectVehicleFromBookingPage(),
    ),
    GoRoute(
      path: '/add-vehicle-booking',
      builder: (context, state) => const AddVehicleFromBookingPage(),
    ),

    GoRoute(
      path: '/select-vehicle-profile',
      builder: (context, state) => const SelectVehicleFromProfilePage(),
    ),
    GoRoute(
      path: '/add-vehicle-profile',
      builder: (context, state) => const AddVehicleFromProfilePage(),
    ),

    GoRoute(
      path: '/select-location-booking',
      builder: (context, state) => const SelectLocationFromBookingPage(),
    ),
    GoRoute(
      path: '/add-location-booking',
      builder: (context, state) => const AddLocationFromBookingPage(),
    ),

    GoRoute(
      path: '/select-location-profile',
      builder: (context, state) => const SelectLocationFromProfilePage(),
    ),
    GoRoute(
      path: '/add-location-profile',
      builder: (context, state) => const AddLocationFromProfilePage(),
    ),

    GoRoute(
      path: '/bill-summary/:id',
      builder: (context, state) => const BillSummaryPage(),
    ),

    // GoRoute(
    //   path: '/payment-gateway',
    //   builder: (context, state) => const PaymentGatewayPage(),
    // ),
    GoRoute(
      path: '/payment-gateway',
      builder: (context, state) {
        final discountedTotal = state.extra as double;
        return PaymentGatewayPage(amount: discountedTotal);
      },
    ),

    GoRoute(
      path: '/payment-done',
      builder: (context, state) {
        final bookingId = state.extra as String;
        return PaymentDonePage(bookingId: bookingId);
      },
    ),

    GoRoute(
      path: '/e-receipt/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return EReceiptPage(bookingId: id);
      },
    ),

    GoRoute(
      path: '/my-bookings',
      builder: (context, state) => const MyBookingsPage(),
    ),
    GoRoute(
      path: '/cancel-booking/:id',
      builder: (context, state) => CancelBookingPage(bookingId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/track-order/:id',
      builder:
          (context, state) =>
              TrackOrderPage(bookingId: state.pathParameters['id']!),
    ),
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
