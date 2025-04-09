import 'package:ridecare/domain/entities/vehicle_entity.dart';

class VehicleModel extends VehicleEntity {
  const VehicleModel({
    required super.id,
    required super.brand,
    required super.model,
    required super.type,
    required super.fuelType,
    required super.registrationNumber,
    required super.userId,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json, String documentId) {
    return VehicleModel(
      id: documentId,
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      type: json['type'] ?? '',
      fuelType: json['fuelType'] ?? '',
      registrationNumber: json['registrationNumber'] ?? '',
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'brand': brand,
      'model': model,
      'type': type,
      'fuelType': fuelType,
      'registrationNumber': registrationNumber,
      'userId': userId,
    };
  }

  // ✅ Convert from Entity to Model
  factory VehicleModel.fromEntity(VehicleEntity entity) {
    return VehicleModel(
      id: entity.id,
      brand: entity.brand,
      model: entity.model,
      type: entity.type,
      fuelType: entity.fuelType,
      registrationNumber: entity.registrationNumber,
      userId: entity.userId,
    );
  }
}
