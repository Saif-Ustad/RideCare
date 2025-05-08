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
    String referralCode,
    String? referredBy,
  ) {
    return remoteDataSource.registerWithEmailAndPassword(
      firstName,
      lastName,
      email,
      password,
      referralCode,
      referredBy,
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
