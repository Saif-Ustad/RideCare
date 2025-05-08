import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserLocationToPrefs(double lat, double lng) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('latitude', lat);
  await prefs.setDouble('longitude', lng);

  await _reverseGeocodeToFullLocation(lat, lng);
}

Future<void> _reverseGeocodeToFullLocation(double lat, double lon) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;

      final fullAddress = [
        place.name,
        place.street,
        place.subLocality,
        place.locality,
        place.administrativeArea,
        place.postalCode,
        place.country,
      ].where((e) => e != null && e.isNotEmpty).join(", ");

      final city = place.locality ?? '';
      final state = place.administrativeArea ?? '';

      final addressObject = {
        'fullAddress': fullAddress,
        'city': city,
        'state': state,
      };

      await prefs.setString('Address_Object', jsonEncode(addressObject));

      print("Saved Address Object: $addressObject");
    }
  } catch (e) {
    print("Failed to get address: $e");
  }
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

Future<Map<String, dynamic>?> getAddressObjectFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final addressJson = prefs.getString('Address_Object');

  if (addressJson != null) {
    final addressMap = jsonDecode(addressJson) as Map<String, dynamic>;
    return addressMap;
  }
  return null;
}
