import '../../repositories/vehicle_repository.dart';

class DeleteVehicleUseCase {
  final VehicleRepository repository;

  DeleteVehicleUseCase({required this.repository});

  Future<void> call(String vehicleId) {
    return repository.deleteVehicle(vehicleId);
  }
}
