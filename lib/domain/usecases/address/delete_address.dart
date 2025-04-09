import '../../repositories/address_repository.dart';

class DeleteAddressUseCase {
  final AddressRepository repository;

  DeleteAddressUseCase({required this.repository});

  Future<void> call(String addressId) {
    return repository.deleteAddress(addressId);
  }
}
