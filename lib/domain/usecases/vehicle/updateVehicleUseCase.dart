import '../../entities/vehicle_entity.dart';
import '../../repositories/vehicle_repository.dart';

class UpdateVehicleUseCase {
  final VehicleRepository repository;

  UpdateVehicleUseCase({required this.repository});

  Future<void> call(VehicleEntity vehicle) {
    return repository.updateVehicle(vehicle);
  }
}
