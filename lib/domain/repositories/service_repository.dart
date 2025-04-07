import '../entities/service_entity.dart';

abstract class ServiceRepository {
  Stream<List<ServiceEntity>> fetchServicesForProvider(String providerId);
}