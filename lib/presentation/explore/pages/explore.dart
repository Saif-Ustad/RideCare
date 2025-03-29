import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridecare/common/widgets/bottomNavigationBar/bottomNavigationBar.dart';
import 'package:ridecare/presentation/explore/widgets/locationFloatingButton.dart';
import 'package:ridecare/presentation/explore/widgets/locationSearchBar.dart';
import 'package:ridecare/presentation/explore/widgets/serviceProviderList.dart';
import '../widgets/customGoogleMap.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  GoogleMapController? _mapController;

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          CustomGoogleMap(onMapCreated: _onMapCreated),
          LocationSearchBar(),
          if (_mapController != null)
            LocationFloatingButton(mapController: _mapController!),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: ServiceProviderList(),
          ),
          BottomNavigationBarSection(),
        ],
      ),
    );
  }
}
