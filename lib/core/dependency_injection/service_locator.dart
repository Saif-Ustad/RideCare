import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:ridecare/core/stripe_service/stripe_customer.dart';
import 'package:ridecare/data/datasources/auth_remote_datasource.dart';
import 'package:ridecare/data/datasources/bookmark_remote_datasource.dart';
import 'package:ridecare/data/repositories/address_repository_impl.dart';
import 'package:ridecare/data/repositories/auth_repository_impl.dart';
import 'package:ridecare/data/repositories/booking_repository_impl.dart';
import 'package:ridecare/data/repositories/bookmark_repository_impl.dart';
import 'package:ridecare/data/repositories/promo_code_repository_Impl.dart';
import 'package:ridecare/data/repositories/service_provider_repository_impl.dart';
import 'package:ridecare/data/repositories/vehicle_repository_impl.dart';
import 'package:ridecare/domain/repositories/auth_repository.dart';
import 'package:ridecare/domain/repositories/bookmark_repository.dart';
import 'package:ridecare/domain/repositories/service_provider_repository.dart';
import 'package:ridecare/domain/usecases/address/add_address.dart';
import 'package:ridecare/domain/usecases/address/get_user_addresses.dart';
import 'package:ridecare/domain/usecases/auth/register_with_email.dart';
import 'package:ridecare/domain/usecases/auth/sign_in_with_email.dart';
import 'package:ridecare/domain/usecases/auth/sign_out.dart';
import 'package:ridecare/domain/usecases/booking/booking_created.dart';
import 'package:ridecare/domain/usecases/booking/booking_updated.dart';
import 'package:ridecare/domain/usecases/booking/prepare_booking_summary.dart';
import 'package:ridecare/domain/usecases/bookmark/toggle_bookmark_service_provider.dart';
import 'package:ridecare/domain/usecases/promoCode/validate_promo_code.dart';
import 'package:ridecare/domain/usecases/service/get_services_for_provider.dart';
import 'package:ridecare/domain/usecases/serviceProvider/get_all_service_providers.dart';
import 'package:ridecare/domain/usecases/serviceProvider/get_nearby_service_providers.dart';
import 'package:ridecare/domain/usecases/vehicle/addVehicleUseCase.dart';
import 'package:ridecare/domain/usecases/vehicle/deleteVehicleUseCase.dart';
import 'package:ridecare/domain/usecases/vehicle/getVehiclesUseCase.dart';
import 'package:ridecare/domain/usecases/vehicle/updateVehicleUseCase.dart';
import 'package:ridecare/presentation/auth/bloc/auth_bloc.dart';
import 'package:ridecare/presentation/auth/bloc/otp_bloc.dart';
import 'package:ridecare/presentation/auth/bloc/password_toggle_bloc.dart';
import 'package:ridecare/presentation/auth/pages/signin.dart';
import 'package:ridecare/presentation/billing/bloc/promoCode/promo_code_bloc.dart';
import 'package:ridecare/presentation/booking/bloc/booking_bloc.dart';
import 'package:ridecare/presentation/home/bloc/serviceProvider/service_provider_bloc.dart';
import 'package:ridecare/presentation/home/pages/home.dart';
import 'package:ridecare/presentation/onboarding/bloc/onboarding_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/datasources/address_remote_datasource.dart';
import '../../data/datasources/booking_remote_datasource.dart';
import '../../data/datasources/promo_code_remote_datasource.dart';
import '../../data/datasources/review_remote_datasource.dart';
import '../../data/datasources/service_provider_remote_datasource.dart';
import '../../data/datasources/service_remote_datasource.dart';
import '../../data/datasources/special_offer_remote_datasource.dart';
import '../../data/datasources/vehicle_remote_datasource.dart';
import '../../data/repositories/review_repository_impl.dart';
import '../../data/repositories/service_repository_imp.dart';
import '../../data/repositories/special_offer_repository_impl.dart';
import '../../domain/repositories/address_repository.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../domain/repositories/promo_code_repository.dart';
import '../../domain/repositories/review_repository.dart';
import '../../domain/repositories/service_repository.dart';
import '../../domain/repositories/special_offer_repository.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../../domain/usecases/address/delete_address.dart';
import '../../domain/usecases/address/update_address.dart';
import '../../domain/usecases/bookmark/get_bookmarked_service_providers.dart';
import '../../domain/usecases/review/get_reviews.dart';
import '../../domain/usecases/specialOffers/get_special_offers.dart';
import '../../presentation/billing/bloc/payment/payment_bloc.dart';
import '../../presentation/bookmark/bloc/bookmark_bloc.dart';
import '../../presentation/home/bloc/specialOffers/special_offer_bloc.dart';
import '../../presentation/location/bloc/address_bloc.dart';
import '../../presentation/serviceProvider/bloc/reviews/review_bloc.dart';
import '../../presentation/serviceProvider/bloc/services/service_bloc.dart';
import '../../presentation/vehicles/bloc/vehicle_bloc.dart';
import '../stripe_service/stripe_service.dart';

final GetIt sl = GetIt.instance;

void setupServiceLocator() {
  // ✅ Register FirebaseAuth instance
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // ✅ Register FirebaseFireStore instance
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);


  // Services
  // sl.registerLazySingleton(() => StripeService());
  sl.registerSingleton<StripeService>(StripeService()..init());
  sl.registerLazySingleton<StripeCustomer>(() => StripeCustomer());


  // ✅ Register Remote Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      auth: sl<FirebaseAuth>(),
      fireStore: sl<FirebaseFirestore>(),
    ),
  );

  sl.registerLazySingleton<SpecialOfferRemoteDataSource>(
    () => SpecialOfferRemoteDataSourceImpl(firestore: sl()),
  );

  sl.registerLazySingleton<ServiceProviderRemoteDataSource>(
    () => ServiceProviderRemoteDataSourceImpl(firestore: sl()),
  );

  sl.registerLazySingleton<ServiceRemoteDataSource>(
    () => ServiceRemoteDataSourceImpl(firestore: sl()),
  );

  sl.registerLazySingleton<BookmarkRemoteDataSource>(
    () => BookmarkRemoteDataSourceImpl(firestore: sl()),
  );

  sl.registerLazySingleton<ReviewRemoteDataSource>(
    () => ReviewRemoteDataSourceImpl(firestore: sl()),
  );

  sl.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceImpl(firestore: sl()),
  );

  sl.registerLazySingleton<VehicleRemoteDataSource>(
    () => VehicleRemoteDataSourceImpl(firestore: sl()),
  );

  sl.registerLazySingleton<AddressRemoteDataSource>(
    () => AddressRemoteDataSourceImpl(firestore: sl()),
  );

  sl.registerLazySingleton<PromoCodeRemoteDataSource>(
    () => PromoCodeRemoteDataSourceImpl(firestore: sl()),
  );

  // ✅ Register Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<SpecialOfferRepository>(
    () => SpecialOfferRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<ServiceProviderRepository>(
    () => ServiceProviderRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<ServiceRepository>(
    () => ServiceRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<BookmarkRepository>(
    () => BookmarkRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<ReviewRepository>(
    () => ReviewRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<VehicleRepository>(
    () => VehicleRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<AddressRepository>(
    () => AddressRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<PromoCodeRepository>(
    () => PromoCodeRepositoryImpl(remoteDataSource: sl()),
  );

  // ✅ Register Use Cases
  sl.registerLazySingleton(() => RegisterWithEmail(repository: sl()));
  sl.registerLazySingleton(() => SignInWithEmail(repository: sl()));
  sl.registerLazySingleton(() => SignOut(repository: sl()));

  sl.registerLazySingleton(() => GetSpecialOffers(repository: sl()));

  sl.registerLazySingleton(() => GetAllServiceProviders(repository: sl()));
  sl.registerLazySingleton(() => GetNearbyServiceProviders(repository: sl()));
  sl.registerLazySingleton(() => GetAllServiceForProvider(repository: sl()));

  sl.registerLazySingleton(
    () => GetBookmarkedServiceProviders(repository: sl()),
  );
  sl.registerLazySingleton(
    () => ToggleBookmarkedServiceProvider(repository: sl()),
  );

  sl.registerLazySingleton(() => GetReviews(repository: sl()));

  sl.registerLazySingleton(() => BookingUpdatedUseCase(repository: sl()));
  sl.registerLazySingleton(() => BookingCreatedUseCase(repository: sl()));
  sl.registerLazySingleton(
    () => PrepareBookingSummaryUseCase(repository: sl()),
  );

  sl.registerLazySingleton(() => AddVehicleUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateVehicleUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetVehiclesUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeleteVehicleUseCase(repository: sl()));

  sl.registerLazySingleton(() => GetUserAddressesUseCase(repository: sl()));
  sl.registerLazySingleton(() => AddAddressUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateAddressUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeleteAddressUseCase(repository: sl()));

  sl.registerLazySingleton(() => ValidatePromoCodeUseCase(repository: sl()));

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

  sl.registerLazySingleton<ServiceProviderBloc>(
    () => ServiceProviderBloc(getAllServiceProviders: sl()),
  );

  sl.registerLazySingleton<ServiceBloc>(
    () => ServiceBloc(getAllServiceForProvider: sl()),
  );

  sl.registerFactory(
    () => BookmarkBloc(getBookmarks: sl(), toggleBookmark: sl()),
  );

  sl.registerFactory(() => ReviewBloc(getReviewsUseCase: sl()));

  sl.registerFactory(
    () => BookingBloc(
      bookingCreatedUseCase: sl(),
      bookingUpdatedUseCase: sl(),
      prepareBookingSummaryUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => VehicleBloc(
      getVehicles: sl(),
      addVehicle: sl(),
      updateVehicle: sl(),
      deleteVehicle: sl(),
    ),
  );

  sl.registerFactory(
    () => AddressBloc(
      getUserAddressesUseCase: sl(),
      addAddressUseCase: sl(),
      updateAddressUseCase: sl(),
      deleteAddressUseCase: sl(),
    ),
  );

  sl.registerLazySingleton<PromoCodeBloc>(
    () => PromoCodeBloc(validatePromoCodeUseCase: sl()),
  );

  sl.registerFactory(() => PaymentBloc(stripeService: sl(), stripeCustomer: sl()));

  sl.registerLazySingleton<GoRouter>(
    () => GoRouter(
      routes: [
        GoRoute(path: '/home', builder: (context, state) => HomePage()),
        GoRoute(path: '/signin', builder: (context, state) => SignInPage()),
      ],
    ),
  );
}
