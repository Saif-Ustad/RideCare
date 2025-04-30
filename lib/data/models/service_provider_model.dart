import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/service_provider_entity.dart';

class ServiceProviderModel extends ServiceProviderEntity {
  const ServiceProviderModel({
    required super.id,
    required super.name,
    required super.ownerName,
    required super.about,
    required super.contactPhone,
    required super.experienceYears,
    required super.profileImageUrl,
    required super.workImageUrl,
    required super.galleryImageUrls,
    required super.rating,
    required super.reviewsCount,
    required super.availability,
    required super.location,
    required super.serviceCharges,
    required super.categoryIds,
    required super.providerServiceIds,
    required super.position,
  });

  factory ServiceProviderModel.fromJson(
    Map<String, dynamic> json,
    String documentId,
  ) {
    return ServiceProviderModel(
      id: documentId,
      name: json['name'] ?? '',
      ownerName: json['ownerName'] ?? '',
      about: json['about'] ?? '',
      contactPhone: json['contactPhone'] ?? '',
      experienceYears: json['experienceYears'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      workImageUrl: json['workImageUrl'] ?? '',
      galleryImageUrls: List<String>.from(json['galleryImageUrls'] ?? []),
      rating: (json['rating'] ?? 0).toDouble(),
      reviewsCount: (json['reviewsCount'] ?? 0).toInt(),
      availability: AvailabilityEntity(
        from: json['availability']?['from'] ?? '',
        to: json['availability']?['to'] ?? '',
      ),
      location: LocationEntity(
        address: json['location']?['address'] ?? '',
        lat: json['location']?['lat'] ?? '',
        lng: json['location']?['lng'] ?? '',
      ),
      serviceCharges: ServiceChargesEntity(
        min: (json['serviceCharges']?['min'] ?? 0).toInt(),
        max: (json['serviceCharges']?['max'] ?? 0).toInt(),
      ),
      categoryIds: List<String>.from(json['categoryIds'] ?? []),
      providerServiceIds: List<String>.from(json['providerServiceIds'] ?? []),
      position: PositionEntity(
        geohash: json['position']?['geohash'] ?? '',
        geopoint: json['position']?['geopoint'] ?? const GeoPoint(0.0, 0.0),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'ownerName': ownerName,
      'about': about,
      'contactPhone': contactPhone,
      'experienceYears': experienceYears,
      'profileImageUrl': profileImageUrl,
      'workImageUrl': workImageUrl,
      'galleryImageUrls': galleryImageUrls,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'availability': {'from': availability.from, 'to': availability.to},
      'location': {
        'address': location.address,
        'lat': location.lat,
        'lng': location.lng,
      },
      'serviceCharges': {'min': serviceCharges.min, 'max': serviceCharges.max},
      'categoryIds': categoryIds,
      'providerServiceIds': providerServiceIds,
      'position':
          position != null
              ? {'geohash': position!.geohash, 'geopoint': position!.geopoint}
              : null,
    };
  }
}
