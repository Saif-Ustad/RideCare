import 'package:ridecare/domain/entities/service_provider_entity.dart';

import '../../domain/repositories/service_provider_repository.dart';
import '../datasources/service_provider_remote_datasource.dart';


class ServiceProviderRepositoryImpl implements ServiceProviderRepository {
  final ServiceProviderRemoteDataSource remoteDataSource;

  ServiceProviderRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<ServiceProviderEntity>> getAllServiceProviders() {
    return remoteDataSource.getAllServiceProviders();
  }

  @override
  Stream<List<ServiceProviderEntity>> getNearbyProviders(double latitude, double longitude) {
      return remoteDataSource.getNearbyProviders(latitude: latitude, longitude: longitude);
  }
}
