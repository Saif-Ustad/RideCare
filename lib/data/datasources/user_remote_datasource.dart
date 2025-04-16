import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ridecare/data/models/user_model.dart';

import '../../common/helper/uploadImageToCloudinary.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getCurrentUser();

  Future<void> updateUserProfile(UserModel user);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  UserRemoteDataSourceImpl({required this.firestore, required this.auth});

  @override
  Future<UserModel> getCurrentUser() async {
    final user = auth.currentUser;
    if (user == null) throw Exception("No user is logged in.");

    final doc = await firestore.collection('users').doc(user.uid).get();
    return UserModel.fromJson(doc.data()!, doc.id);
  }

  @override
  Future<void> updateUserProfile(UserModel user) async {
    String? finalImageUrl;
    if (user.userProfileImageUrl != null &&
        !user.userProfileImageUrl!.startsWith("http")) {
      final file = File(user.userProfileImageUrl!);
      try {
        finalImageUrl = await uploadImageToCloudinary(file);
      } catch (e) {
        print("Error uploading image to Cloudinary: $e");
      }
    }

    final userMap = user.toJson();
    if (finalImageUrl != null) {
      userMap['userProfileImageUrl'] = finalImageUrl;
    }
    await firestore.collection("users").doc(user.uid).update(userMap);
  }
}
