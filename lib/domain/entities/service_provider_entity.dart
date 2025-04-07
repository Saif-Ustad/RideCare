class ServiceProviderEntity {
  final String id;
  final String name;
  final String ownerName;
  final String about;
  final String contactPhone;
  final String experienceYears;
  final String profileImageUrl;
  final String workImageUrl;
  final double rating;
  final int reviewsCount;
  final AvailabilityEntity availability;
  final LocationEntity location;
  final ServiceChargesEntity serviceCharges;
  final List<String> categoryIds;
  final List<String> providerServiceIds;

  const ServiceProviderEntity({
    required this.id,
    required this.name,
    required this.ownerName,
    required this.about,
    required this.contactPhone,
    required this.experienceYears,
    required this.profileImageUrl,
    required this.workImageUrl,
    required this.rating,
    required this.reviewsCount,
    required this.availability,
    required this.location,
    required this.serviceCharges,
    required this.categoryIds,
    required this.providerServiceIds,
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
