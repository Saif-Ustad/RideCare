import '../../entities/vehicle_entity.dart';
import '../../repositories/vehicle_repository.dart';

class AddVehicleUseCase {
  final VehicleRepository repository;

  AddVehicleUseCase({required this.repository});

  Future<void> call(VehicleEntity vehicle) {
    return repository.addVehicle(vehicle);
  }
}
