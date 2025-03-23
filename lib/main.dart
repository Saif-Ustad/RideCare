// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridecare/presentation/auth/bloc/auth_bloc.dart';
import 'package:ridecare/presentation/auth/bloc/password_toggle_bloc.dart';
import 'package:ridecare/presentation/auth/bloc/otp_bloc.dart';
import 'package:ridecare/presentation/auth/pages/form.dart';
import 'package:ridecare/presentation/auth/pages/signin.dart';
import 'package:ridecare/presentation/auth/pages/signup.dart';
import 'package:ridecare/presentation/auth/pages/verify.dart';
import 'package:ridecare/presentation/explore/pages/explore.dart';
import 'package:ridecare/presentation/home/pages/home.dart';
import 'package:ridecare/presentation/splash/pages/splash.dart';
import 'package:ridecare/core/configs/theme/app_theme.dart';
import 'package:ridecare/core/dependency_injection/service_locator.dart';
import 'package:ridecare/presentation/onboarding/bloc/onboarding_bloc.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: true); // ✅ Disable reCAPTCHA for testing

  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OnboardingBloc>(
          create: (context) => sl<OnboardingBloc>(),
        ),
        BlocProvider<PasswordToggleBloc>(
          create: (context) => sl<PasswordToggleBloc>(),
        ),
        BlocProvider<OtpBloc>(
          create: (context) => sl<OtpBloc>(),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => sl<AuthBloc>(),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        title: 'RideCare',
        home:  ExplorePage(),
      ),
    );
  }
}
