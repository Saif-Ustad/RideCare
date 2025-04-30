import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserLocationToPrefs(double lat, double lng) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('latitude', lat);
  await prefs.setDouble('longitude', lng);
}

Future<Position?> getUserLocationFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final lat = prefs.getDouble('latitude');
  final lng = prefs.getDouble('longitude');

  if (lat != null && lng != null) {
    return Position(
      latitude: lat,
      longitude: lng,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
      floor: null,
      isMocked: false,
    );
  }
  return null;
}
