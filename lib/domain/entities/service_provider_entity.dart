import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceProviderEntity {
  final String id;
  final String name;
  final String ownerName;
  final String about;
  final String contactPhone;
  final String experienceYears;
  final String profileImageUrl;
  final String workImageUrl;
  final List<String> galleryImageUrls;
  final double rating;
  final int reviewsCount;
  final AvailabilityEntity availability;
  final LocationEntity location;
  final ServiceChargesEntity serviceCharges;
  final List<String> categoryIds;
  final List<String> providerServiceIds;
  final PositionEntity? position;

  final String? distanceText;
  final String? durationText;

  const ServiceProviderEntity({
    required this.id,
    required this.name,
    required this.ownerName,
    required this.about,
    required this.contactPhone,
    required this.experienceYears,
    required this.profileImageUrl,
    required this.workImageUrl,
    required this.galleryImageUrls,
    required this.rating,
    required this.reviewsCount,
    required this.availability,
    required this.location,
    required this.serviceCharges,
    required this.categoryIds,
    required this.providerServiceIds,
    this.position,
    this.distanceText,
    this.durationText,
  });
}

class AvailabilityEntity {
  final String from;
  final String to;

  const AvailabilityEntity({required this.from, required this.to});
}

class LocationEntity {
  final String address;
  final String lat;
  final String lng;

  const LocationEntity({
    required this.address,
    required this.lat,
    required this.lng,
  });
}

class ServiceChargesEntity {
  final int min;
  final int max;

  const ServiceChargesEntity({
    required this.min,
    required this.max,
  });
}


class PositionEntity {
  final String geohash;
  final GeoPoint geopoint;

  const PositionEntity({
    required this.geohash,
    required this.geopoint,
  });
}


extension ServiceProviderEntityCopy on ServiceProviderEntity {
  ServiceProviderEntity copyWith({
    String? id,
    String? name,
    String? ownerName,
    String? about,
    String? contactPhone,
    String? experienceYears,
    String? profileImageUrl,
    String? workImageUrl,
    List<String>? galleryImageUrls,
    double? rating,
    int? reviewsCount,
    AvailabilityEntity? availability,
    LocationEntity? location,
    ServiceChargesEntity? serviceCharges,
    List<String>? categoryIds,
    List<String>? providerServiceIds,
    PositionEntity? position,
    String? distanceText,
    String? durationText,
  }) {
    return ServiceProviderEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerName: ownerName ?? this.ownerName,
      about: about ?? this.about,
      contactPhone: contactPhone ?? this.contactPhone,
      experienceYears: experienceYears ?? this.experienceYears,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      workImageUrl: workImageUrl ?? this.workImageUrl,
      galleryImageUrls: galleryImageUrls ?? this.galleryImageUrls,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      availability: availability ?? this.availability,
      location: location ?? this.location,
      serviceCharges: serviceCharges ?? this.serviceCharges,
      categoryIds: categoryIds ?? this.categoryIds,
      providerServiceIds: providerServiceIds ?? this.providerServiceIds,
      position: position ?? this.position,
      distanceText: distanceText ?? this.distanceText,
      durationText: durationText ?? this.durationText,
    );
  }
}
