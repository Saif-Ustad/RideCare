import '../../entities/address_entity.dart';
import '../../repositories/address_repository.dart';

class UpdateAddressUseCase {
  final AddressRepository repository;

  UpdateAddressUseCase({required this.repository});

  Future<void> call(AddressEntity address) {
    return repository.updateAddress(address);
  }
}
