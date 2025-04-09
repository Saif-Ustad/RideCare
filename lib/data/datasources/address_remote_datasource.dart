import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ridecare/data/models/address_model.dart';

abstract class AddressRemoteDataSource {
  Future<List<AddressModel>> getUserAddresses(String userId);

  Future<void> addAddress(AddressModel address);

  Future<void> updateAddress(AddressModel address);

  Future<void> deleteAddress(String addressId);
}

class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  final FirebaseFirestore firestore;

  AddressRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<AddressModel>> getUserAddresses(String userId) async {
    final snapshot =
        await firestore
            .collection('addresses')
            .where('userId', isEqualTo: userId)
            .get();

    return snapshot.docs
        .map((doc) => AddressModel.fromJson(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<void> addAddress(AddressModel address) {
    return firestore.collection('addresses').add(address.toJson());
  }

  @override
  Future<void> deleteAddress(String addressId) {
    return firestore.collection('addresses').doc(addressId).delete();
  }

  @override
  Future<void> updateAddress(AddressModel address) {
    return firestore
        .collection('addresses')
        .doc(address.id)
        .update(address.toJson());
  }
}
