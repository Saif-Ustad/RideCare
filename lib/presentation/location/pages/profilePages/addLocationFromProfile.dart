// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:latlong2/latlong.dart';
//
// class AddLocationPage extends StatefulWidget {
//   const AddLocationPage({super.key});
//
//   @override
//   State<AddLocationPage> createState() => _AddLocationPageState();
// }
//
// class _AddLocationPageState extends State<AddLocationPage> {
//   final TextEditingController _searchController = TextEditingController();
//   LatLng? _selectedLocation;
//   late MapController _mapController;
//   bool _isLoading = false; // Track loading state
//
//   @override
//   void initState() {
//     super.initState();
//     _mapController = MapController();
//   }
//
//   // Get user's current location
//   Future<void> _getCurrentLocation() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       _showSnackBar("Location services are disabled.");
//       setState(() => _isLoading = false);
//       return;
//     }
//
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         _showSnackBar("Location permission denied.");
//         setState(() => _isLoading = false);
//         return;
//       }
//     }
//
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//
//       setState(() {
//         _selectedLocation = LatLng(position.latitude, position.longitude);
//         _mapController.move(_selectedLocation!, 15);
//       });
//
//       await _reverseGeocode(position.latitude, position.longitude);
//     } catch (e) {
//       _showSnackBar("Error getting location: $e");
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   // Reverse geocoding (Convert LatLng to Address)
//   Future<void> _reverseGeocode(double lat, double lon) async {
//     final url = Uri.parse(
//       "https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon",
//     );
//     final response = await http.get(url);
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       setState(() {
//         _searchController.text = data['display_name'];
//       });
//     } else {
//       _showSnackBar("Failed to get address.");
//     }
//   }
//
//   // Geocode (Convert Address to LatLng)
//   Future<void> _searchLocation() async {
//     String query = _searchController.text;
//     if (query.isEmpty) return;
//
//     final url = Uri.parse(
//       "https://nominatim.openstreetmap.org/search?q=$query&format=json",
//     );
//     final response = await http.get(url);
//
//     if (response.statusCode == 200) {
//       final List data = json.decode(response.body);
//       if (data.isNotEmpty) {
//         final lat = double.parse(data[0]['lat']);
//         final lon = double.parse(data[0]['lon']);
//         setState(() {
//           _selectedLocation = LatLng(lat, lon);
//           _mapController.move(_selectedLocation!, 15);
//         });
//       } else {
//         _showSnackBar("No results found.");
//       }
//     } else {
//       _showSnackBar("Failed to search location.");
//     }
//   }
//
//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text(message)));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Enter Your Location")),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(10),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: "Search your location",
//                 prefixIcon: const Icon(Icons.search),
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: _searchLocation,
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 10),
//
//           GestureDetector(
//             onTap: _isLoading ? null : _getCurrentLocation,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 _isLoading
//                     ? const CircularProgressIndicator(color: Colors.purple)
//                     : const Icon(Icons.my_location, color: Colors.purple),
//                 const SizedBox(width: 10),
//                 Text(
//                   _isLoading ? "Fetching location..." : "Use my current location",
//                   style: const TextStyle(
//                     color: Colors.purple,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 10),
//
//           Expanded(
//             child: FlutterMap(
//               mapController: _mapController,
//               options: MapOptions(
//                 center: _selectedLocation ?? const LatLng(18.5204, 73.8567),
//                 zoom: 15,
//                 onTap: (tapPosition, LatLng location) async {
//                   setState(() {
//                     _selectedLocation = location;
//                   });
//
//                   // Reverse Geocode
//                   await _reverseGeocode(location.latitude, location.longitude);
//                 },
//               ),
//               children: [
//                 TileLayer(
//                   urlTemplate:
//                   "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//                   subdomains: ['a', 'b', 'c'],
//                 ),
//                 if (_selectedLocation != null)
//                   MarkerLayer(
//                     markers: [
//                       Marker(
//                         point: _selectedLocation!,
//                         width: 40,
//                         height: 40,
//                         child: const Icon(
//                           Icons.location_on,
//                           size: 40,
//                           color: Colors.red,
//                         ),
//                       ),
//                     ],
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:ridecare/common/widgets/bottomBar/bottomBar.dart';
import 'package:ridecare/domain/entities/address_entity.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/configs/theme/app_colors.dart';
import '../../bloc/address_bloc.dart';
import '../../bloc/address_event.dart';

class AddLocationFromProfilePage extends StatefulWidget {
  const AddLocationFromProfilePage({super.key});

  @override
  State<AddLocationFromProfilePage> createState() => _AddLocationFromProfilePageState();
}

class _AddLocationFromProfilePageState extends State<AddLocationFromProfilePage> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  bool _isLoading = false;
  Set<Marker> _markers = {};
  TextEditingController _addressTitleController = TextEditingController();
  TextEditingController _fullAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackBar("Location services are disabled.");
      setState(() => _isLoading = false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackBar("Location permission denied.");
        setState(() => _isLoading = false);
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _updateMapLocation(LatLng(position.latitude, position.longitude));
      await _reverseGeocode(position.latitude, position.longitude);
    } catch (e) {
      _showSnackBar("Error getting location: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _reverseGeocode(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        String fullAddress = [
          place.name,
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.postalCode,
          place.country,
        ].where((element) => element != null && element.isNotEmpty).join(", ");

        setState(() {
          _fullAddressController.text = fullAddress;
        });
      }
    } catch (e) {
      _showSnackBar("Failed to get address.");
    }
  }

  void _updateMapLocation(LatLng location) {
    setState(() {
      _selectedLocation = location;
      _markers = {
        Marker(
          markerId: const MarkerId("selected-location"),
          position: location,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      };
    });

    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(location, 15));
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _buildLeadingIconButton(() => context.pop()),
        title: const Text(
          "Select Location",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lightGray,
                    ),
                    onPressed: _isLoading ? null : _getCurrentLocation,
                    icon:
                        _isLoading
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                                strokeWidth: 2,
                              ),
                            )
                            : const Icon(
                              Icons.my_location,
                              color: AppColors.primary,
                            ),
                    label: Text(
                      _isLoading ? "Fetching..." : "Use Current Location",
                      style: TextStyle(color: AppColors.black),
                    ),
                  ),

                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lightGray,
                    ),
                    onPressed: () {
                      _showSnackBar("Tap on the map to pin a location.");
                    },
                    icon: const Icon(Icons.map, color: AppColors.primary),
                    label: const Text(
                      "Use Map",
                      style: TextStyle(color: AppColors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _selectedLocation ?? const LatLng(18.5204, 73.8567),
                zoom: 15,
              ),
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              onTap: (LatLng location) async {
                _updateMapLocation(location);
                await _reverseGeocode(location.latitude, location.longitude);
              },
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Address Title (Home, Office, etc.)",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 3),
                SizedBox(
                  height: 50,
                  child: TextField(
                    controller: _addressTitleController,
                    decoration: InputDecoration(
                      hintText: "Enter title",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Full Address",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 3),
                TextField(
                  controller: _fullAddressController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Enter full address",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        text: "Save Address",
        onPressed: () {
          final userId = FirebaseAuth.instance.currentUser?.uid;

          if (_selectedLocation != null &&
              _addressTitleController.text.isNotEmpty &&
              _fullAddressController.text.isNotEmpty &&
              userId != null) {
            final address = AddressEntity(
              id: const Uuid().v4(),
              userId: userId,
              title: _addressTitleController.text.trim(),
              address: _fullAddressController.text.trim(),
            );

            context.read<AddressBloc>().add(AddAddress(address));
            context.push('/select-location-profile');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Please select a location and fill all fields"),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildLeadingIconButton(VoidCallback onPressed) => Padding(
    padding: const EdgeInsets.only(left: 15),
    child: Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.darkGrey, width: 1),
        color: Colors.white,
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
        onPressed: onPressed,
        constraints: const BoxConstraints(),
        padding: EdgeInsets.zero,
      ),
    ),
  );
}
