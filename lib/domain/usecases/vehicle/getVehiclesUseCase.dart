import '../../entities/vehicle_entity.dart';
import '../../repositories/vehicle_repository.dart';

class GetVehiclesUseCase {
  final VehicleRepository repository;

  GetVehiclesUseCase({required this.repository});

  Stream<List<VehicleEntity>> call(String userId) {
    return repository.getVehicles(userId);
  }
}
