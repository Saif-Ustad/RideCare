import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:ridecare/data/datasources/auth_remote_datasource.dart';
import 'package:ridecare/data/repositories/auth_repository_impl.dart';
import 'package:ridecare/domain/repositories/auth_repository.dart';
import 'package:ridecare/domain/usecases/register_with_email.dart';
import 'package:ridecare/domain/usecases/sign_in_with_email.dart';
import 'package:ridecare/domain/usecases/sign_out.dart';
import 'package:ridecare/presentation/auth/bloc/auth_bloc.dart';
import 'package:ridecare/presentation/auth/bloc/otp_bloc.dart';
import 'package:ridecare/presentation/auth/bloc/password_toggle_bloc.dart';
import 'package:ridecare/presentation/onboarding/bloc/onboarding_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final GetIt sl = GetIt.instance;

void setupServiceLocator() {
  // ✅ Register FirebaseAuth instance
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // ✅ Register FirebaseFireStore instance
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // ✅ Register Remote Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      sl<FirebaseAuth>(),
      sl<FirebaseFirestore>(),
    ),
  );

  // ✅ Register Auth Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );

  // ✅ Register Use Cases
  sl.registerLazySingleton(() => RegisterWithEmail(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignInWithEmail(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignOut(sl<AuthRepository>()));

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
}
