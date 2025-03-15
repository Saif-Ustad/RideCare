import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.uid,
    super.email,
    super.phoneNumber,
    super.displayName,
    super.photoURL,
  });

  // Factory method to convert Firebase User to UserModel
  factory UserModel.fromFirebaseUser(dynamic user) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      phoneNumber: user.phoneNumber,
      displayName: user.displayName,
      photoURL: user.photoURL,
    );
  }

  // Convert UserModel to Map for serialization
  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "email": email,
      "phoneNumber": phoneNumber,
      "displayName": displayName,
      "photoURL": photoURL,
    };
  }

  // Convert from JSON Map to UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json["uid"] ?? '',
      email: json["email"],
      phoneNumber: json["phoneNumber"],
      displayName: json["displayName"],
      photoURL: json["photoURL"],
    );
  }
}
