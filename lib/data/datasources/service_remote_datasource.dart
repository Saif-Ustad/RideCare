import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/service_model.dart';

abstract class ServiceRemoteDataSource {
  Stream<List<ServiceModel>> fetchServicesForProvider(String providerId);
}
class ServiceRemoteDataSourceImpl implements ServiceRemoteDataSource {
  final FirebaseFirestore firestore;

  ServiceRemoteDataSourceImpl({required this.firestore});

  @override
  Stream<List<ServiceModel>> fetchServicesForProvider(String providerId) async* {
    final providerDocStream =
    firestore.collection('service_providers').doc(providerId).snapshots();

    await for (var providerDoc in providerDocStream) {
      final providerData = providerDoc.data();

      if (providerData == null || !providerData.containsKey('providerServiceIds')) {
        yield [];
        continue;
      }

      List<ServiceModel> services = [];

      for (String serviceRefId in List<String>.from(providerData['providerServiceIds'])) {
        final serviceSnapshot = await firestore.collection('provider_services').doc(serviceRefId).get();
        final serviceData = serviceSnapshot.data();

        if (serviceData == null) continue;

        final mainServiceSnapshot =
        await firestore.collection('services').doc(serviceData['serviceId']).get();
        final mainServiceData = mainServiceSnapshot.data();

        if (mainServiceData == null) continue;

        // Fetch the category document using the categoryId from the main service
        final categorySnapshot =
        await firestore.collection('categories').doc(mainServiceData['categoryId']).get();
        final categoryData = categorySnapshot.data();

        if (categoryData == null) continue;

        // Inject 'id' to mainServiceData
        final mainServiceJson = {
          ...mainServiceData,
          'id': mainServiceSnapshot.id,
        };

        final serviceModel = ServiceModel.fromJson(serviceData, mainServiceJson, categoryData);
        services.add(serviceModel);
      }

      yield services;
    }
  }
}
