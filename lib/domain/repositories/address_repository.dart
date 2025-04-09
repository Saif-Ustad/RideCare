import '../entities/address_entity.dart';

abstract class AddressRepository {
  Future<List<AddressEntity>> getUserAddresses(String userId);

  Future<void> addAddress(AddressEntity address);

  Future<void> updateAddress(AddressEntity address);

  Future<void> deleteAddress(String addressId);
}
