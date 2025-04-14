import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ridecare/data/models/user_model.dart';
import 'package:ridecare/domain/entities/user_entity.dart';

abstract class AuthRemoteDataSource {
  Future<void> registerWithEmailAndPassword(
    String firstName,
    String lastName,
    String email,
    String password,
  );

  Future<UserModel> signInWithEmailAndPassword(String email, String password);

  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore fireStore;

  AuthRemoteDataSourceImpl({required this.auth, required this.fireStore});

  @override
  Future<void> registerWithEmailAndPassword(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    try {
      // Create user with email and password
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store user data in FireStore
      await fireStore.collection('users').doc(userCredential.user!.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final doc =
          await fireStore.collection('users').doc(credential.user!.uid).get();

      if (doc.exists) {
        return UserModel.fromJson(doc.data()!, doc.id);
      } else {
        throw Exception('No user data found in Firestore.');
      }
    } catch (e) {
      throw Exception('Sign-in failed: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await auth.signOut();
  }
}
