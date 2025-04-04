import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:ridecare/data/datasources/auth_remote_datasource.dart';
import 'package:ridecare/data/repositories/auth_repository_impl.dart';
import 'package:ridecare/domain/repositories/auth_repository.dart';
import 'package:ridecare/domain/usecases/register_with_email.dart';
import 'package:ridecare/domain/usecases/sign_in_with_email.dart';
import 'package:ridecare/domain/usecases/sign_out.dart';
import 'package:ridecare/presentation/auth/bloc/auth_bloc.dart';
import 'package:ridecare/presentation/auth/bloc/otp_bloc.dart';
import 'package:ridecare/presentation/auth/bloc/password_toggle_bloc.dart';
import 'package:ridecare/presentation/auth/pages/signin.dart';
import 'package:ridecare/presentation/home/pages/home.dart';
import 'package:ridecare/presentation/onboarding/bloc/onboarding_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/datasources/special_offer_remote_datasource.dart';
import '../../data/repositories/special_offer_repository_impl.dart';
import '../../domain/repositories/special_offer_repository.dart';
import '../../domain/usecases/get_special_offers.dart';
import '../../presentation/home/bloc/specialOffers/special_offer_bloc.dart';

final GetIt sl = GetIt.instance;

void setupServiceLocator() {
  // ✅ Register FirebaseAuth instance
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // ✅ Register FirebaseFireStore instance
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // ✅ Register Remote Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<FirebaseAuth>(), sl<FirebaseFirestore>()),
  );

  sl.registerLazySingleton<SpecialOfferRemoteDataSource>(
    () => SpecialOfferRemoteDataSourceImpl(firestore: sl()),
  );

  // ✅ Register Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );

  sl.registerLazySingleton<SpecialOfferRepository>(
    () => SpecialOfferRepositoryImpl(remoteDataSource: sl()),
  );

  // ✅ Register Use Cases
  sl.registerLazySingleton(() => RegisterWithEmail(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignInWithEmail(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignOut(sl<AuthRepository>()));

  sl.registerLazySingleton(() => GetSpecialOffers(repository: sl()));

  // ✅ Register BLoCs
  sl.registerLazySingleton<OnboardingBloc>(() => OnboardingBloc());
  sl.registerLazySingleton<PasswordToggleBloc>(() => PasswordToggleBloc());
  sl.registerLazySingleton<OtpBloc>(() => OtpBloc());

  sl.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      registerWithEmail: sl<RegisterWithEmail>(),
      signInWithEmail: sl<SignInWithEmail>(),
      signOut: sl<SignOut>(),
    ),
  );

  sl.registerLazySingleton<SpecialOfferBloc>(
    () => SpecialOfferBloc(getSpecialOffers: sl()),
  );

  sl.registerLazySingleton<GoRouter>(
    () => GoRouter(
      routes: [
        GoRoute(path: '/home', builder: (context, state) => HomePage()),
        GoRoute(path: '/signin', builder: (context, state) => SignInPage()),
      ],
    ),
  );
}
