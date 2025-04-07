import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/service_provider_model.dart';

abstract class ServiceProviderRemoteDataSource {
  Stream<List<ServiceProviderModel>> getAllServiceProviders();
  Stream<List<ServiceProviderModel>> getNearbyProviders();
}

class ServiceProviderRemoteDataSourceImpl implements ServiceProviderRemoteDataSource {
  final FirebaseFirestore firestore;

  ServiceProviderRemoteDataSourceImpl({required this.firestore});

  @override
  Stream<List<ServiceProviderModel>> getAllServiceProviders() {
    return firestore.collection('service_providers').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ServiceProviderModel.fromJson(doc.data(), doc.id);
      }).toList();
    });
  }

  @override
  Stream<List<ServiceProviderModel>> getNearbyProviders() {
    // TODO: implement getNearbyProviders
    throw UnimplementedError();
  }
}
