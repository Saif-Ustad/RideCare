import '../../entities/service_entity.dart';
import '../../repositories/service_repository.dart';

class GetAllServiceForProvider {
  final ServiceRepository repository;

  GetAllServiceForProvider({required this.repository});

  Stream<List<ServiceEntity>> call(String providerId) {
    return repository.fetchServicesForProvider(providerId);
  }
}
