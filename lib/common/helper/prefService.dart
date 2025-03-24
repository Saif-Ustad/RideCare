import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  static Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);
  }

  static Future<bool> isOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_seen') ?? false;
  }

  /// Firebase Authentication Integration
  static bool isUserLoggedIn() {
    final user = FirebaseAuth.instance.currentUser;
    return user != null; // Returns true if user is logged in
  }

  /// Log out the user and clear local preferences
  static Future<void> logoutUser() async {
    await FirebaseAuth.instance.signOut();
  }
}
