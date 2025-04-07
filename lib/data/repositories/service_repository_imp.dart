import 'package:ridecare/domain/entities/service_entity.dart';
import '../../domain/repositories/service_repository.dart';
import '../datasources/service_remote_datasource.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceRemoteDataSource remoteDataSource;

  ServiceRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<ServiceEntity>> fetchServicesForProvider(String providerId) {
    return remoteDataSource.fetchServicesForProvider(providerId);
  }
}
