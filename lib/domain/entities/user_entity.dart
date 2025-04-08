class UserEntity {
  final String uid;
  final String? email;
  final String? phoneNumber;
  final String? displayName;
  final String? photoURL;
  final List<String>? bookmarkIds;

  UserEntity({
    required this.uid,
    this.email,
    this.phoneNumber,
    this.displayName,
    this.photoURL,
    this.bookmarkIds,
  });

  UserEntity copyWith({
    String? uid,
    String? email,
    String? phoneNumber,
    String? displayName,
    String? photoURL,
    List<String>? bookmarkIds,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      bookmarkIds: bookmarkIds ?? this.bookmarkIds,
    );
  }
}
