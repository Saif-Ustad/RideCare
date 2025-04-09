import '../../domain/repositories/vehicle_repository.dart';
import '../../domain/entities/vehicle_entity.dart';
import '../datasources/vehicle_remote_datasource.dart';
import '../models/vehicle_model.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final VehicleRemoteDataSource remoteDataSource;

  VehicleRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<VehicleEntity>> getVehicles(String userId) {
    return remoteDataSource.getVehicles(userId);
  }

  @override
  Future<void> addVehicle(VehicleEntity vehicle) async {
    return await remoteDataSource.addVehicle(VehicleModel.fromEntity(vehicle));
  }

  @override
  Future<void> updateVehicle(VehicleEntity vehicle) async {
    return await remoteDataSource.updateVehicle(VehicleModel.fromEntity(vehicle));
  }

  @override
  Future<void> deleteVehicle(String vehicleId) async {
    return await remoteDataSource.deleteVehicle(vehicleId);
  }
}
