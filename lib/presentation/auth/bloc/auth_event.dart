import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}


// Register user with email & password
class RegisterEvent extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String? referredByCode;

  const RegisterEvent(this.firstName, this.lastName, this.email, this.password, this.referredByCode );

  @override
  List<Object?> get props => [email, password];
}


// Login user with email & password
class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}


// Logout event
class LogoutEvent extends AuthEvent {}

