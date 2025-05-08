import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../common/helper/generate_referral_code.dart';
import '../../../domain/entities/notification_entity.dart';
import '../../../domain/usecases/auth/register_with_email.dart';
import '../../../domain/usecases/auth/sign_in_with_email.dart';
import '../../../domain/usecases/auth/sign_out.dart';
import '../../home/bloc/notification/notification_bloc.dart';
import '../../home/bloc/notification/notification_event.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterWithEmail registerWithEmail;
  final SignInWithEmail signInWithEmail;
  final SignOut signOut;

  final NotificationBloc notificationBloc = GetIt.I<NotificationBloc>();

  AuthBloc({
    required this.registerWithEmail,
    required this.signInWithEmail,
    required this.signOut,
  }) : super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final referralCode = generateReferralCode(event.firstName);

      final userId = await registerWithEmail(
        event.firstName,
        event.lastName,
        event.email,
        event.password,
        referralCode,
        event.referredByCode,
      );
      emit(Unauthenticated()); // Redirect to login after registration

      final NotificationEntity notification = NotificationEntity(
        title: "Hi ${event.firstName}, welcome to RideCare!",
        body: "Let’s take care of your car with RideCare.",
        type: "Sign Up",
      );

      notificationBloc.add(
        AddNotificationEvent(userId: userId, notification: notification),
      );
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await signInWithEmail(event.email, event.password);
      if (user != null) {
        emit(Authenticated(user));

        final NotificationEntity notification = NotificationEntity(
          title: "Welcome back, ${user.firstName}!",
          body: "Let’s take care of your car with RideCare.",
          type: "login",
        );

        notificationBloc.add(
          AddNotificationEvent(userId: user.uid, notification: notification),
        );
      } else {
        emit(AuthError("Invalid email or password"));
      }
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    try {
      await signOut();
      emit(Unauthenticated());
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }
}
