import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ridecare/core/configs/routes/router.dart';
import 'package:ridecare/presentation/auth/bloc/auth_bloc.dart';
import 'package:ridecare/presentation/auth/bloc/password_toggle_bloc.dart';
import 'package:ridecare/presentation/auth/bloc/otp_bloc.dart';
import 'package:ridecare/core/configs/theme/app_theme.dart';
import 'package:ridecare/core/dependency_injection/service_locator.dart';
import 'package:ridecare/presentation/billing/bloc/payment/payment_bloc.dart';
import 'package:ridecare/presentation/billing/bloc/promoCode/promo_code_bloc.dart';
import 'package:ridecare/presentation/booking/bloc/booking_bloc.dart';
import 'package:ridecare/presentation/bookmark/bloc/bookmark_bloc.dart';
import 'package:ridecare/presentation/home/bloc/serviceProvider/service_provider_bloc.dart';
import 'package:ridecare/presentation/home/bloc/specialOffers/special_offer_bloc.dart';
import 'package:ridecare/presentation/location/bloc/address_bloc.dart';
import 'package:ridecare/presentation/onboarding/bloc/onboarding_bloc.dart';
import 'package:ridecare/presentation/serviceProvider/bloc/reviews/review_bloc.dart';
import 'package:ridecare/presentation/serviceProvider/bloc/services/service_bloc.dart';
import 'package:ridecare/presentation/vehicles/bloc/vehicle_bloc.dart';

import 'core/stripe_service/stripe_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OnboardingBloc>(create: (context) => sl<OnboardingBloc>()),
        BlocProvider<PasswordToggleBloc>(
          create: (context) => sl<PasswordToggleBloc>(),
        ),
        BlocProvider<OtpBloc>(create: (context) => sl<OtpBloc>()),
        BlocProvider<AuthBloc>(create: (context) => sl<AuthBloc>()),
        BlocProvider<SpecialOfferBloc>(
          create: (context) => sl<SpecialOfferBloc>(),
        ),
        BlocProvider<ServiceProviderBloc>(
          create: (context) => sl<ServiceProviderBloc>(),
        ),
        BlocProvider<ServiceBloc>(create: (context) => sl<ServiceBloc>()),
        BlocProvider<BookmarkBloc>(create: (context) => sl<BookmarkBloc>()),
        BlocProvider<ReviewBloc>(create: (context) => sl<ReviewBloc>()),
        BlocProvider<BookingBloc>(create: (context) => sl<BookingBloc>()),
        BlocProvider<VehicleBloc>(create: (context) => sl<VehicleBloc>()),
        BlocProvider<AddressBloc>(create: (context) => sl<AddressBloc>()),
        BlocProvider<PromoCodeBloc>(create: (context) => sl<PromoCodeBloc>()),
        BlocProvider<PaymentBloc>(create: (context) => sl<PaymentBloc>()),
      ],
      child: PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop && GoRouter.of(context).canPop()) {
            GoRouter.of(context).pop();
          }
        },
        child: MaterialApp.router(
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          title: 'RideCare',
          routerConfig: router,
        ),
      ),
    );
  }
}
