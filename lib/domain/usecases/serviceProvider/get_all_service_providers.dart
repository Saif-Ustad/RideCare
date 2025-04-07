import 'package:ridecare/domain/entities/service_provider_entity.dart';
import '../../repositories/service_provider_repository.dart';

class GetAllServiceProviders {
  final ServiceProviderRepository repository;

  GetAllServiceProviders({required this.repository});

  Stream<List<ServiceProviderEntity>> call() {
    return repository.getAllServiceProviders();
  }
}
