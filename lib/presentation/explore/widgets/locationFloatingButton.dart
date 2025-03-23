import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/configs/theme/app_colors.dart';

class LocationFloatingButton extends StatelessWidget {
  final GoogleMapController mapController;

  const LocationFloatingButton({super.key, required this.mapController});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 300,
      right: 15,
      child: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () async {
          String message = "Fetching location...";
          _showSnackbar(context, message);

          Position? position = await _determinePosition(context);
          if (position != null) {
            LatLng userLocation = LatLng(position.latitude, position.longitude);

            // Move the camera to the user's location
            mapController.animateCamera(
              CameraUpdate.newLatLngZoom(userLocation, 18),
            );

            _showSnackbar(context, "Location updated!");
          }
        },
        child: const Icon(Icons.my_location, color: Colors.white, size: 24),
      ),
    );
  }

  /// Function to determine user location and handle errors
  Future<Position?> _determinePosition(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackbar(context, "Location services are disabled. Enable it.");

      // Open location settings
      await Geolocator.openLocationSettings();
      return null;
    }

    // Check and request location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackbar(context, "Location permissions are denied.");
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showSnackbar(
        context,
        "Location permissions are permanently denied. Please enable them in settings.",
      );

      // Open app settings
      await Geolocator.openAppSettings();
      return null;
    }

    // Get the current position
    return await Geolocator.getCurrentPosition();
  }

  /// Function to show messages in a Snackbar
  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
    );
  }
}
