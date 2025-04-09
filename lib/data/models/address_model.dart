import '../../domain/entities/address_entity.dart';

class AddressModel extends AddressEntity {
  AddressModel({
    required super.id,
    required super.address,
    required super.title,
    required super.userId,
  });

  factory AddressModel.fromJson(String id, Map<String, dynamic> data) {
    return AddressModel(
      id: id,
      address: data['address'],
      title: data['title'],
      userId: data['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'address': address, 'title': title, 'userId': userId};
  }

  // ✅ Convert from Entity to Model
  factory AddressModel.fromEntity(AddressEntity entity) {
    return AddressModel(
      id: entity.id,
      address: entity.address,
      title: entity.title,
      userId: entity.userId,
    );
  }
}
