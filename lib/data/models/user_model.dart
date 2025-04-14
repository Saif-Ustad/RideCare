import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.uid,
    super.email,
    super.phoneNumber,
    super.displayName,
    super.firstName,
    super.lastName,
    super.userProfileImageUrl,
    super.bookmarkIds,
  });

  // Factory method to create UserModel from Firestore JSON
  factory UserModel.fromJson(Map<String, dynamic> json, String userId) {
    return UserModel(
      uid: userId,
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      displayName: json['displayName'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      userProfileImageUrl: json['userProfileImageUrl'],
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
      'firstName': firstName,
      'lastName': lastName,
      'userProfileImageUrl': userProfileImageUrl,
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
      firstName: user.firstName,
      lastName: user.lastName,
      userProfileImageUrl: user.photoURL,
      bookmarkIds: [], // Not available from FirebaseAuth directly
    );
  }
}
