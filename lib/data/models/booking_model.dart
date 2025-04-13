import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ridecare/domain/entities/booking_entity.dart';
import 'package:ridecare/domain/entities/service_provider_entity.dart';
import 'package:ridecare/domain/entities/vehicle_entity.dart';
import 'package:ridecare/domain/entities/address_entity.dart';
import 'package:ridecare/domain/entities/service_entity.dart';
import 'package:ridecare/domain/entities/user_entity.dart';

class BookingModel extends BookingEntity {
  BookingModel({
    super.bookingId,
    super.serviceIds,
    super.services,
    super.serviceProviderId,
    super.serviceProvider,
    super.scheduledAt,
    super.note,
    super.vehicleId,
    super.vehicleInfo,
    super.addressId,
    super.addressInfo,
    super.userId,
    super.user,
    super.trackingId,
    super.paymentMode,
    super.status,
    super.serviceType,
    super.totalCharges,
    super.promoCodeInfo,
  });

  // ✅ Convert from Firestore document
  factory BookingModel.fromJson(Map<String, dynamic> json, String id) {
    return BookingModel(
      bookingId: id,
      serviceIds: List<String>.from(json['serviceIds'] ?? []),
      serviceProviderId: json['serviceProviderId'],
      serviceProvider:
          json['serviceProvider'] != null
              ? ServiceProviderEntity(
                id: json['serviceProvider']['id'],
                name: json['serviceProvider']['name'],
                ownerName: '',
                about: '',
                contactPhone: '',
                experienceYears: '',
                profileImageUrl: '',
                workImageUrl: json['serviceProvider']['workImageUrl'],
                galleryImageUrls: [''],
                rating: json['serviceProvider']['rating'],
                reviewsCount: json['serviceProvider']['reviewsCount'],
                availability: AvailabilityEntity(from: "", to: ""),
                location: LocationEntity(address: "", lat: "", lng: ""),
                serviceCharges: ServiceChargesEntity(min: 0, max: 0),
                categoryIds: [""],
                providerServiceIds: [""],
              )
              : null,
      scheduledAt: (json['scheduledAt'] as Timestamp?)?.toDate(),
      note: json['note'],
      vehicleId: json['vehicleId'],
      vehicleInfo:
          json['vehicleInfo'] != null
              ? VehicleEntity(
                id: json['vehicleInfo']['id'] ?? '',
                brand: json['vehicleInfo']['brand'] ?? '',
                model: json['vehicleInfo']['model'] ?? '',
                type: json['vehicleInfo']['type'],
                fuelType: json['vehicleInfo']['fuelType'],
                registrationNumber: json['vehicleInfo']['registrationNumber'],
                userId: '',
              )
              : null,
      addressId: json['addressId'],
      addressInfo:
          json['addressInfo'] != null
              ? AddressEntity(
                id: json['addressInfo']['id'] ?? '',
                address: json['addressInfo']['address'] ?? '',
                title: '',
                userId: '',
              )
              : null,
      userId: json['userId'],
      user:
          json['userInfo'] != null
              ? UserEntity(
                uid: json['userInfo']['uid'] ?? '',
                displayName: json['userInfo']['displayName'],
                email: json['userInfo']['email'],
              )
              : null,
      services:
          (json['services'] as List<dynamic>?)
              ?.map(
                (s) => ServiceEntity(
                  id: s['id'],
                  name: s['name'],
                  description: '',
                  iconUrl: '',
                  subCategory: '',
                  categoryId: '',
                  categoryName: '',
                  price: (s['price'] ?? 0).toDouble(),
                  estimatedTime: 0,
                  isAvailable: true, // default
                ),
              )
              .toList(),
      trackingId: json['trackingId'],
      paymentMode: json['paymentMode'],
      status: json['status'],
      serviceType: json['serviceType'],
      totalCharges: (json['totalCharges'] as num).toDouble(),
      promoCodeInfo:
          json['promoCodeInfo'] != null
              ? {
                'code': json['promoCodeInfo']['code'],
                'discountPercentage':
                    (json['promoCodeInfo']['discountPercentage'] as num).toDouble(),
              }
              : null,
    );
  }

  // ✅ Convert to Firestore document (only selected fields)
  Map<String, dynamic> toJson() {
    return {
      'serviceIds': serviceIds,
      'serviceProviderId': serviceProviderId,
      'serviceProvider':
          serviceProvider != null
              ? {
                'id': serviceProvider!.id,
                'name': serviceProvider!.name,
                'workImageUrl': serviceProvider!.workImageUrl,
                'rating': serviceProvider!.rating,
                'reviewsCount': serviceProvider!.reviewsCount,
              }
              : null,
      'scheduledAt':
          scheduledAt != null ? Timestamp.fromDate(scheduledAt!) : null,
      'note': note,
      'vehicleId': vehicleId,
      'vehicleInfo':
      vehicleInfo != null
              ? {
                'id': vehicleInfo!.id,
                'brand': vehicleInfo!.brand,
                'model': vehicleInfo!.model,
                'type' : vehicleInfo!.type,
                'registrationNumber': vehicleInfo!.registrationNumber,
                'fuelType': vehicleInfo!.fuelType,
              }
              : null,
      'addressId': addressId,
      'addressInfo':
      addressInfo != null
              ? {'id': addressInfo!.id, 'address': addressInfo!.address}
              : null,
      'userId': userId,
      'userInfo':
          user != null
              ? {'uid': user!.uid, 'displayName': user!.displayName, 'email': user!.email}
              : null,
      'services':
          services
              ?.map((s) => {'id': s.id, 'name': s.name, 'price': s.price})
              .toList(),
      'trackingId': trackingId,
      'paymentMode': paymentMode,
      'status': status,
      'serviceType': serviceType,
      'totalCharges': totalCharges,
      'promoCodeInfo': promoCodeInfo,
    };
  }

  // ✅ Optional: from BookingEntity to BookingModel
  factory BookingModel.fromEntity(BookingEntity entity) {
    return BookingModel(
      bookingId: entity.bookingId,
      serviceIds: entity.serviceIds,
      serviceProvider: entity.serviceProvider,
      services: entity.services,
      serviceProviderId: entity.serviceProviderId,
      scheduledAt: entity.scheduledAt,
      note: entity.note,
      vehicleId: entity.vehicleId,
      vehicleInfo: entity.vehicleInfo,
      addressId: entity.addressId,
      addressInfo: entity.addressInfo,
      userId: entity.userId,
      user: entity.user,
      trackingId: entity.trackingId,
      paymentMode: entity.paymentMode,
      status: entity.status,
      serviceType: entity.serviceType,
      totalCharges: entity.totalCharges,
      promoCodeInfo: entity.promoCodeInfo,
    );
  }
}
