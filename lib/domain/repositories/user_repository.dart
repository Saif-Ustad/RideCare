import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity> getCurrentUser();
  Future<void> updateUserProfile(UserEntity user);
}
