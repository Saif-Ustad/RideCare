import '../../entities/user_entity.dart';
import '../../repositories/auth_repository.dart';

class SignInWithEmail {
  final AuthRepository repository;

  SignInWithEmail({required this.repository});

  Future<UserEntity?> call(String email, String password) {
    return repository.signInWithEmailAndPassword(email, password);
  }
}
