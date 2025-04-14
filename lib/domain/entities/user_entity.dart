class UserEntity {
  final String uid;
  final String? email;
  final String? phoneNumber;
  final String? displayName;
  final String? userProfileImageUrl;
  final String? firstName;
  final String? lastName;
  final List<String>? bookmarkIds;

  UserEntity({
    required this.uid,
    this.email,
    this.phoneNumber,
    this.displayName,
    this.firstName,
    this.lastName,
    this.userProfileImageUrl,
    this.bookmarkIds,
  });

  UserEntity copyWith({
    String? uid,
    String? email,
    String? phoneNumber,
    String? displayName,
    String? firstName,
    String? lastName,
    String? userProfileImageUrl,
    List<String>? bookmarkIds,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      displayName: displayName ?? this.displayName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      userProfileImageUrl: userProfileImageUrl ?? this.userProfileImageUrl,
      bookmarkIds: bookmarkIds ?? this.bookmarkIds,
    );
  }
}
