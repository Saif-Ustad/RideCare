import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/vehicle_model.dart';

abstract class VehicleRemoteDataSource {
  Stream<List<VehicleModel>> getVehicles(String userId);

  Future<void> addVehicle(VehicleModel vehicle);

  Future<void> updateVehicle(VehicleModel vehicle);

  Future<void> deleteVehicle(String vehicleId);
}

class VehicleRemoteDataSourceImpl implements VehicleRemoteDataSource {
  final FirebaseFirestore firestore;

  VehicleRemoteDataSourceImpl({required this.firestore});

  @override
  Stream<List<VehicleModel>> getVehicles(String userId) {
    return firestore
        .collection('vehicles')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return VehicleModel.fromJson(doc.data(), doc.id);
          }).toList();
        });
  }

  @override
  Future<void> addVehicle(VehicleModel vehicle) {
    return firestore.collection('vehicles').add(vehicle.toJson());
  }

  @override
  Future<void> updateVehicle(VehicleModel vehicle) {
    return firestore
        .collection('vehicles')
        .doc(vehicle.id)
        .update(vehicle.toJson());
  }

  @override
  Future<void> deleteVehicle(String vehicleId) {
    return firestore.collection('vehicles').doc(vehicleId).delete();
  }
}
