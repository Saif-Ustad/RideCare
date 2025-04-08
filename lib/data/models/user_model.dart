import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.uid,
    super.email,
    super.phoneNumber,
    super.displayName,
    super.photoURL,
    super.bookmarkIds,
  });

  // Factory method to create UserModel from Firestore JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      displayName: json['displayName'],
      photoURL: json['photoURL'],
      bookmarkIds: json['bookmarkIds'] != null
          ? List<String>.from(json['bookmarkIds'])
          : [],
    );
  }

  // Serialize UserModel to Firestore JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'phoneNumber': phoneNumber,
      'displayName': displayName,
      'photoURL': photoURL,
      'bookmarkIds': bookmarkIds ?? [],
    };
  }

  // Optional: Factory method to convert Firebase Auth User to UserModel (for login/registration only)
  factory UserModel.fromFirebaseUser(dynamic user) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      phoneNumber: user.phoneNumber,
      displayName: user.displayName,
      photoURL: user.photoURL,
      bookmarkIds: [], // Not available from FirebaseAuth directly
    );
  }
}
