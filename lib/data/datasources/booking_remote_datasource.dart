import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ridecare/data/models/booking_model.dart';
import 'package:ridecare/data/models/service_provider_model.dart';

import '../../domain/entities/service_entity.dart';
import '../models/address_model.dart';
import '../models/vehicle_model.dart';

abstract class BookingRemoteDataSource {
  Future<String> createBooking(BookingModel booking);

  Future<void> updateBooking(String bookingId, Map<String, dynamic> data);

  Future<BookingModel> prepareBillSummary(BookingModel booking);

  Future<List<BookingModel>> getAllBookings(String userId);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final FirebaseFirestore firestore;

  BookingRemoteDataSourceImpl({required this.firestore});

  @override
  Future<String> createBooking(BookingModel booking) async {
    final docRef = await firestore.collection('bookings').add(booking.toJson());
    await firestore.collection('users').doc(booking.userId).update({
      'bookingIds': FieldValue.arrayUnion([docRef.id]),
    });
    return docRef.id;
  }

  @override
  Future<void> updateBooking(
    String bookingId,
    Map<String, dynamic> data,
  ) async {
    await firestore.collection('bookings').doc(bookingId).update(data);
  }

  @override
  Future<BookingModel> prepareBillSummary(BookingModel booking) async {
    try {
      final providerServicesSnapshot =
          await firestore
              .collection('provider_services')
              .where(FieldPath.documentId, whereIn: booking.serviceIds)
              .get();

      final List<ServiceEntity> serviceEntities = [];

      for (final doc in providerServicesSnapshot.docs) {
        final providerService = doc.data();
        final serviceId = providerService['serviceId'];

        if (serviceId == null) continue;

        final serviceDoc =
            await firestore.collection('services').doc(serviceId).get();
        final serviceData = serviceDoc.data();

        if (serviceData != null) {
          final categoryId = serviceData['categoryId'];

          final categoryDoc =
              await firestore.collection('categories').doc(categoryId).get();
          final categoryData = categoryDoc.data();
          final categoryName = categoryData?['name'] ?? '';

          final service = ServiceEntity(
            id: doc.id,
            name: serviceData['name'] ?? '',
            description: serviceData['description'] ?? '',
            iconUrl: serviceData['iconUrl'] ?? '',
            subCategory: serviceData['subCategory'] ?? '',
            categoryId: categoryId ?? '',
            categoryName: categoryName,
            price: (providerService['price'] ?? 0).toDouble(),
            estimatedTime: providerService['estimatedTime'] ?? 0,
            isAvailable: providerService['isAvailable'] ?? false,
          );

          serviceEntities.add(service);
        } else {
          print("⚠️ Service data not found for ID: $serviceId");
        }
      }

      final vehicleSnapshot =
          await firestore.collection('vehicles').doc(booking.vehicleId).get();

      final selectedVehicle =
          vehicleSnapshot.exists
              ? VehicleModel.fromJson(
                vehicleSnapshot.data()!,
                vehicleSnapshot.id,
              )
              : throw Exception(
                'Vehicle not found for ID: ${booking.vehicleId}',
              );

      final addressSnapshot =
          await firestore.collection('addresses').doc(booking.addressId).get();

      final selectedAddress =
          addressSnapshot.exists
              ? AddressModel.fromJson(
                addressSnapshot.id,
                addressSnapshot.data()!,
              )
              : throw Exception(
                'Address not found for ID: ${booking.addressId}',
              );

      final serviceProviderSnapshot =
          await firestore
              .collection('service_providers')
              .doc(booking.serviceProviderId)
              .get();

      final selectedServiceProvider =
          serviceProviderSnapshot.exists
              ? ServiceProviderModel.fromJson(
                serviceProviderSnapshot.data()!,
                serviceProviderSnapshot.id,
              )
              : throw Exception(
                'Service Provider not found for ID: ${booking.serviceProviderId}',
              );

      return BookingModel(
        serviceProvider: selectedServiceProvider,
        services: serviceEntities,
        vehicleInfo: selectedVehicle,
        addressInfo: selectedAddress,
      );
    } catch (e) {
      throw Exception('❌ Failed to prepare bill summary: $e');
    }
  }

  @override
  Future<List<BookingModel>> getAllBookings(String userId) async {
    final userDoc = await firestore.collection('users').doc(userId).get();
    final userData = userDoc.data();

    if (userData == null || !userData.containsKey('bookingIds')) {
      return [];
    }

    final List<dynamic> bookingIds = userData['bookingIds'];
    List<BookingModel> bookings = [];

    for (String id in bookingIds) {
      final docSnapshot = await firestore.collection('bookings').doc(id).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          bookings.add(BookingModel.fromJson(data, docSnapshot.id));
        }
      }
    }

    return bookings;
  }
}
