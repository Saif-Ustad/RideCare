import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> registerWithEmailAndPassword(
    String firstName,
    String lastName,
    String email,
    String password,
  ) {
    return remoteDataSource.registerWithEmailAndPassword(
      firstName,
      lastName,
      email,
      password,
    );
  }

  @override
  Future<UserEntity> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final userCredential = await remoteDataSource.signInWithEmailAndPassword(
      email,
      password,
    );

    return userCredential;
  }

  @override
  Future<void> signOut() {
    return remoteDataSource.signOut();
  }
}
