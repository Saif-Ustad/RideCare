import '../../repositories/auth_repository.dart';

class RegisterWithEmail {
  final AuthRepository repository;

  RegisterWithEmail({required this.repository});

  Future<void> call(String firstName, String lastName, String email, String password) {
    return repository.registerWithEmailAndPassword(firstName, lastName, email, password);
  }
}
