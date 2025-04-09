import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ridecare/core/configs/assets/app_vectors.dart';
import 'package:ridecare/presentation/bookmark/bloc/bookmark_bloc.dart';
import 'package:ridecare/presentation/home/bloc/serviceProvider/service_provider_bloc.dart';
import 'package:ridecare/presentation/home/bloc/serviceProvider/service_provider_event.dart';
import 'package:ridecare/presentation/vehicles/bloc/vehicle_bloc.dart';
import 'package:ridecare/presentation/vehicles/bloc/vehicle_event.dart';

import '../../bookmark/bloc/bookmark_event.dart';
import '../../home/bloc/specialOffers/special_offer_bloc.dart';
import '../../home/bloc/specialOffers/special_offer_event.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _loadData();
    _navigateToNext();
  }

  Future<void> _loadData() async {
    context.read<SpecialOfferBloc>().add(FetchSpecialOffers());
    context.read<ServiceProviderBloc>().add(FetchAllServiceProviders());
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      context.read<BookmarkBloc>().add(LoadBookmarks(currentUser.uid));
      context.read<VehicleBloc>().add(LoadVehicles(currentUser.uid));
    }

  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SvgPicture.asset(
          AppVectors.logo,
          width: screenSize.width * 0.2,
          height: screenSize.height * 0.15,
        ),
      ),
    );
  }
}
