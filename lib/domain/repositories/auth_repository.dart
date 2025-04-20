import 'package:firebase_auth/firebase_auth.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<String> registerWithEmailAndPassword(String firstName, String lastName, String email, String password);
  Future<UserEntity?> signInWithEmailAndPassword(String email, String password);
  Future<void> signOut();
}
