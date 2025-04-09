import 'package:ridecare/domain/entities/address_entity.dart';
import 'package:ridecare/domain/repositories/address_repository.dart';

class AddAddressUseCase {
  final AddressRepository repository;

  AddAddressUseCase({required this.repository});

  Future<void> call(AddressEntity address) {
    return repository.addAddress(address);
  }
}
