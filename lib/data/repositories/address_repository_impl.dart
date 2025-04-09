import 'package:ridecare/data/datasources/address_remote_datasource.dart';
import 'package:ridecare/domain/entities/address_entity.dart';
import '../../domain/repositories/address_repository.dart';
import '../models/address_model.dart';

class AddressRepositoryImpl implements AddressRepository {
  AddressRemoteDataSource remoteDataSource;

  AddressRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<AddressEntity>> getUserAddresses(String userId) async {
    return remoteDataSource.getUserAddresses(userId);
  }

  @override
  Future<void> addAddress(AddressEntity address) async {
    return await remoteDataSource.addAddress(AddressModel.fromEntity(address));
  }

  @override
  Future<void> updateAddress(AddressEntity address) async {
    return await remoteDataSource.updateAddress(
      AddressModel.fromEntity(address),
    );
  }

  @override
  Future<void> deleteAddress(String addressId) async {
    return await remoteDataSource.deleteAddress(addressId);
  }
}
