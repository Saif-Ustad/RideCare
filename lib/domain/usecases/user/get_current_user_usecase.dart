import 'package:ridecare/domain/entities/user_entity.dart';
import 'package:ridecare/domain/repositories/user_repository.dart';

class GetCurrentUserUseCase {
  final UserRepository repository;

  GetCurrentUserUseCase({required this.repository});

  Future<UserEntity> call() {
    return repository.getCurrentUser();
  }
}
