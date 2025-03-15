import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/register_with_email.dart';
import '../../../domain/usecases/sign_in_with_email.dart';
import '../../../domain/usecases/sign_out.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterWithEmail registerWithEmail;
  final SignInWithEmail signInWithEmail;
  final SignOut signOut;

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
      await registerWithEmail(event.firstName, event.lastName, event.email, event.password);
      emit(Unauthenticated()); // Redirect to login after registration
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
