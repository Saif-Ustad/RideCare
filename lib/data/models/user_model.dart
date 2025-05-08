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
    super.gender,
    super.referralCode,
    super.referralPoints,
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
      gender: json['gender'],
      bookmarkIds:
          json['bookmarkIds'] != null
              ? List<String>.from(json['bookmarkIds'])
              : [],
      referralCode: json['referralCode'],
      referralPoints: json['referralPoints'],
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
      'gender': gender,
      'referralCode': referralCode,
      'referralPoints': referralPoints,
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
      bookmarkIds: [],
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      uid: entity.uid,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      displayName: entity.displayName,
      firstName: entity.firstName,
      lastName: entity.lastName,
      userProfileImageUrl: entity.userProfileImageUrl,
      bookmarkIds: entity.bookmarkIds,
      gender: entity.gender,
      referralCode: entity.referralCode,
      referralPoints: entity.referralPoints,
    );
  }
}
