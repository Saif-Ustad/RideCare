import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/configs/theme/app_colors.dart';

class CustomGoogleMap extends StatefulWidget {
  final Function(GoogleMapController) onMapCreated;

  const CustomGoogleMap({super.key, required this.onMapCreated});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  GoogleMapController? _mapController;

  final LatLng _center = const LatLng(18.4631, 73.8937);
  final Set<Marker> _markers = {}; // Store markers

  final List<Map<String, dynamic>> serviceProviders = [
    {"name": "Bajaj Service Center", "location": LatLng(18.494698, 73.834732)},
    {"name": "Honda Service Center", "location": LatLng(18.474748, 73.855292)},
    {"name": "Toyota Service Center", "location": LatLng(18.452000, 73.847208)},
  ];

  @override
  void initState() {
    super.initState();
    _addMarkers();
  }

  void _addMarkers() {
    final Set<Marker> newMarkers = {};
    double primaryHue = HSLColor.fromColor(AppColors.primary).hue;

    for (var provider in serviceProviders) {
      newMarkers.add(
        Marker(
          markerId: MarkerId(provider["name"]),
          position: provider["location"],
          infoWindow: InfoWindow(title: provider["name"]),
          icon: BitmapDescriptor.defaultMarkerWithHue(primaryHue),
        ),
      );
    }

    setState(() {
      _markers.clear();
      _markers.addAll(newMarkers);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
    widget.onMapCreated(controller);
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(target: _center, zoom: 14.0),
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      markers: _markers,
    );
  }
}
