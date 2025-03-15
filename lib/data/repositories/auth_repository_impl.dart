import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> registerWithEmailAndPassword(String firstName, String lastName, String email, String password) {
    return remoteDataSource.registerWithEmailAndPassword(firstName, lastName, email, password);
  }

  @override
  Future<UserEntity?> signInWithEmailAndPassword(String email, String password) async {
    final userCredential = await remoteDataSource.signInWithEmailAndPassword(email, password);
    if (userCredential != null) {
      return UserModel.fromFirebaseUser(userCredential);
    }
    return null;
  }

  @override
  Future<void> signOut() {
    return remoteDataSource.signOut();
  }
}
