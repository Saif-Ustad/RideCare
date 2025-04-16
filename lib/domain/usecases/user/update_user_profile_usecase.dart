import 'package:ridecare/domain/entities/user_entity.dart';
import 'package:ridecare/domain/repositories/user_repository.dart';

class UpdateUserProfileUseCase {
  final UserRepository repository;

  UpdateUserProfileUseCase({required this.repository});

  Future<void> call(UserEntity user) async {
    await repository.updateUserProfile(user);
  }
}
