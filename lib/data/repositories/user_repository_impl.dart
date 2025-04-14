import 'package:ridecare/domain/entities/user_entity.dart';
import 'package:ridecare/domain/repositories/user_repository.dart';

import '../datasources/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity> getCurrentUser() async {
    return remoteDataSource.getCurrentUser();
  }
}
