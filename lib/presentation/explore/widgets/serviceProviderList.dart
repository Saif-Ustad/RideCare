import 'package:flutter/material.dart';
import 'package:ridecare/presentation/explore/widgets/serviceProviderCard.dart';
import '../../../core/configs/assets/app_images.dart';

class ServiceProviderList extends StatelessWidget {
  ServiceProviderList({super.key});

  final List<ServiceProvider> serviceProviders = [
    ServiceProvider(
      "1",
      "Bajaj Service Center",
      "0.5 km",
      "2 Mins",
      "100-1200",
      AppImages.popularServiceProvider1,
    ),
    ServiceProvider(
      "1",
      "Honda Service Center",
      "1.5 km",
      "8 Mins",
      "200-1500",
      AppImages.popularServiceProvider2,
    ),
    ServiceProvider(
      "1",
      "Toyota Service Center",
      "0.5 km",
      "2 Mins",
      "500-2300",
      AppImages.popularServiceProvider3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.only(bottom: 70),
        height: 200,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 15),
          children:
            serviceProviders
                .map((provider) => ServiceProviderCard(provider: provider))
                .toList(),
        ),
      ),
    );
  }
}
