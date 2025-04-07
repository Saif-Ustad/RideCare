import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDataSource {
  Future<void> registerWithEmailAndPassword(String firstName, String lastName, String email, String password);
  Future<User?> signInWithEmailAndPassword(String email, String password);
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore fireStore;

  AuthRemoteDataSourceImpl({required this.auth, required this.fireStore});

  @override
  Future<void> registerWithEmailAndPassword(
      String firstName, String lastName, String email, String password) async {
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
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    final credential = await auth.signInWithEmailAndPassword(email: email, password: password);
    return credential.user;
  }

  @override
  Future<void> signOut() async {
    await auth.signOut();
  }
}
