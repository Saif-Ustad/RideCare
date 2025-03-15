import 'package:equatable/equatable.dart';

abstract class OtpState extends Equatable {
  @override
  List<Object> get props => [];
}

// Initial state
class OtpInitial extends OtpState {}

// When OTP is being sent
class OtpSending extends OtpState {}

// When OTP is successfully sent
class OtpSent extends OtpState {
  final String verificationId;

  OtpSent(this.verificationId);

  @override
  List<Object> get props => [verificationId];
}

// When OTP is being verified
class OtpSubmitting extends OtpState {}

// When OTP verification is successful
class OtpSuccess extends OtpState {}

// When OTP verification fails
class OtpFailure extends OtpState {
  final String error;

  OtpFailure(this.error);

  @override
  List<Object> get props => [error];
}

// When invalid OTP is entered
class OtpInvalid extends OtpState {}
