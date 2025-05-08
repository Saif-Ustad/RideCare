import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ridecare/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<String> registerWithEmailAndPassword(
    String firstName,
    String lastName,
    String email,
    String password,
    String referralCode,
    String? referredBy,
  );

  Future<UserModel> signInWithEmailAndPassword(String email, String password);

  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore fireStore;

  AuthRemoteDataSourceImpl({required this.auth, required this.fireStore});

  @override
  Future<String> registerWithEmailAndPassword(
    String firstName,
    String lastName,
    String email,
    String password,
    String referralCode,
    String? referredBy,
  ) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final String userId = userCredential.user!.uid;

      // Store user data in FireStore
      await fireStore.collection('users').doc(userId).set({
        'firstName': firstName,
        'lastName': lastName,
        'displayName': "$firstName $lastName",
        'email': email,
        'createdAt': DateTime.now(),
        'referralCode': referralCode,
        'referredBy': referredBy,
      });

      // If referredBy exists, give referrer a reward
      if (referredBy != null && referredBy.isNotEmpty) {
        final referrerSnapshot = await fireStore
            .collection('users')
            .where('referralCode', isEqualTo: referredBy)
            .limit(1)
            .get();

        if (referrerSnapshot.docs.isNotEmpty) {
          final referrerDoc = referrerSnapshot.docs.first;
          final referrerId = referrerDoc.id;

          await fireStore.collection('users').doc(referrerId).update({
            'referralPoints': FieldValue.increment(10),
          });

          // Optionally record referral history
          await fireStore.collection('referrals').add({
            'referrerId': referrerId,
            'referredUserId': userId,
            'timestamp': DateTime.now(),
          });
        }
      }

      return userId;
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
