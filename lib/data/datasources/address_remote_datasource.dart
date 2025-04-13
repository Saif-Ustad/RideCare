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
    final userDoc = await firestore.collection('users').doc(userId).get();
    final addressIds = List<String>.from(userDoc.data()?['addressIds'] ?? []);

    final addressFutures = addressIds.map((id) async {
      final doc = await firestore.collection('addresses').doc(id).get();
      if (doc.exists) {
        return AddressModel.fromJson(doc.id, doc.data()!);
      }
      return null;
    });

    final addressList = await Future.wait(addressFutures);
    return addressList.whereType<AddressModel>().toList();
  }

  @override
  Future<void> addAddress(AddressModel address) async {
    final addressRef = await firestore
        .collection('addresses')
        .add(address.toJson());

    await firestore.collection('users').doc(address.userId).update({
      'addressIds': FieldValue.arrayUnion([addressRef.id]),
    });
  }

  @override
  Future<void> deleteAddress(String addressId) async {
    final addressDoc =
        await firestore.collection('addresses').doc(addressId).get();

    if (addressDoc.exists) {
      final userId = addressDoc.data()?['userId'];

      await firestore.collection('addresses').doc(addressId).delete();

      if (userId != null) {
        await firestore.collection('users').doc(userId).update({
          'addressIds': FieldValue.arrayRemove([addressId]),
        });
      }
    }
  }

  @override
  Future<void> updateAddress(AddressModel address) {
    return firestore
        .collection('addresses')
        .doc(address.id)
        .update(address.toJson());
  }
}
