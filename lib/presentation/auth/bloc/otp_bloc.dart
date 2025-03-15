import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'otp_event.dart';
import 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;

  OtpBloc() : super(OtpInitial()) {
    on<SendOtp>(_onSendOtp);
    on<SubmitOtp>(_onSubmitOtp);
  }

  Future<void> _onSendOtp(SendOtp event, Emitter<OtpState> emit) async {
    emit(OtpSending());

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: event.phoneNumber,
        timeout: const Duration(seconds: 60),

        // 🔹 Auto-verification (rare case, for some devices)
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await _auth.signInWithCredential(credential);
            emit(OtpSuccess());
          } catch (e) {
            emit(OtpFailure("Auto verification failed: ${e.toString()}"));
          }
        },

        // 🔹 OTP verification failed
        verificationFailed: (FirebaseAuthException e) {
          emit(OtpFailure(e.message ?? "OTP verification failed"));
        },

        // 🔹 OTP Sent - Ask user to enter manually
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          emit(OtpSent(verificationId));
        },

        // 🔹 OTP Auto-Retrieval Timeout
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          emit(OtpFailure("OTP auto-retrieval timed out. Enter OTP manually."));
        },
      );
    } catch (e) {
      emit(OtpFailure("Failed to send OTP: ${e.toString()}"));
    }
  }

  // Handling OTP submission
  Future<void> _onSubmitOtp(SubmitOtp event, Emitter<OtpState> emit) async {
    emit(OtpSubmitting());

    if (_verificationId == null) {
      emit(OtpFailure("Verification ID is missing"));
      return;
    }

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: event.otpCode,
      );

      await _auth.signInWithCredential(credential);
      emit(OtpSuccess());
    } catch (e) {
      emit(OtpFailure("Invalid OTP: ${e.toString()}"));
    }
  }
}
