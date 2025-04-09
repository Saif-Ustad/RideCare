import 'package:ridecare/domain/entities/address_entity.dart';
import 'package:ridecare/domain/repositories/address_repository.dart';

class GetUserAddressesUseCase {
  final AddressRepository repository;

  GetUserAddressesUseCase({required this.repository});

  Future<List<AddressEntity>> call(String userId) {
    return repository.getUserAddresses(userId);
  }
}
