import 'package:equatable/equatable.dart';

abstract class OtpEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Event to send OTP
class SendOtp extends OtpEvent {
  final String phoneNumber;

  SendOtp(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

// Event to submit OTP
class SubmitOtp extends OtpEvent {
  final String otpCode;

  SubmitOtp(this.otpCode);

  @override
  List<Object> get props => [otpCode];
}

// Event to resend OTP
class ResendOtp extends OtpEvent {}
