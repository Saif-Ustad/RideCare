import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridecare/common/widgets/bottomNavigationBar/bottomNavigationBar.dart';
import 'package:ridecare/presentation/explore/widgets/locationFloatingButton.dart';
import 'package:ridecare/presentation/explore/widgets/locationSearchBar.dart';
import 'package:ridecare/presentation/explore/widgets/serviceProviderList.dart';
import '../../home/bloc/serviceProvider/service_provider_bloc.dart';
import '../../home/bloc/serviceProvider/service_provider_state.dart';
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
    return BlocBuilder<ServiceProviderBloc, ServiceProviderState>(
      builder: (context, serviceProviderState) {
        if (serviceProviderState is ServiceProviderLoaded) {
          return Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                CustomGoogleMap(onMapCreated: _onMapCreated, serviceProviders: serviceProviderState.serviceProviders),
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
        } else if (serviceProviderState is ServiceProviderLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (serviceProviderState is ServiceProviderError) {
          return Center(child: Text(serviceProviderState.message));
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
