import 'package:ridecare/domain/entities/vehicle_entity.dart';

abstract class VehicleRepository {
  Stream<List<VehicleEntity>> getVehicles(String userId);

  Future<void> addVehicle(VehicleEntity vehicle);

  Future<void> updateVehicle(VehicleEntity vehicle);

  Future<void> deleteVehicle(String vehicleId);
}
