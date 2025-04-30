import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire3/geoflutterfire3.dart';
import '../models/service_provider_model.dart';

abstract class ServiceProviderRemoteDataSource {
  Stream<List<ServiceProviderModel>> getAllServiceProviders();

  Stream<List<ServiceProviderModel>> getNearbyProviders({
    required double latitude,
    required double longitude,
  });
}

class ServiceProviderRemoteDataSourceImpl
    implements ServiceProviderRemoteDataSource {
  final FirebaseFirestore firestore;
  final GeoFlutterFire geo;

  ServiceProviderRemoteDataSourceImpl({required this.firestore, required this.geo});

  @override
  Stream<List<ServiceProviderModel>> getAllServiceProviders() {
    return firestore.collection('service_providers').snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        return ServiceProviderModel.fromJson(doc.data(), doc.id);
      }).toList();
    });
  }

  @override
  Stream<List<ServiceProviderModel>> getNearbyProviders({
    required double latitude,
    required double longitude,
  }) {
    final center = geo.point(latitude: latitude, longitude: longitude);
    final collectionRef = firestore.collection('service_providers');

    final stream = geo
        .collection(collectionRef: collectionRef)
        .within(center: center, radius: 50000, field: 'position');

    return stream.map((documents) {
      return documents.map((doc) {
        return ServiceProviderModel.fromJson(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }
}
