import '../entities/service_provider_entity.dart';

abstract class ServiceProviderRepository {
  Stream<List<ServiceProviderEntity>> getAllServiceProviders();
  Stream<List<ServiceProviderEntity>> getNearbyProviders(double lat, double lng);
}