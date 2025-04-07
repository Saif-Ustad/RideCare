import 'package:ridecare/domain/entities/service_provider_entity.dart';
import '../../repositories/service_provider_repository.dart';

class GetNearbyServiceProviders {
  final ServiceProviderRepository repository;

  GetNearbyServiceProviders({required this.repository});

  Stream<List<ServiceProviderEntity>> call(double lat, double lng) {
    return repository.getNearbyProviders(lat, lng);
  }
}
