import '../../repositories/auth_repository.dart';

class RegisterWithEmail {
  final AuthRepository repository;

  RegisterWithEmail({required this.repository});

  Future<String> call(
    String firstName,
    String lastName,
    String email,
    String password,
    String referralCode,
    String? referredBy,
  ) {
    return repository.registerWithEmailAndPassword(
      firstName,
      lastName,
      email,
      password,
      referralCode,
      referredBy,
    );
  }
}
