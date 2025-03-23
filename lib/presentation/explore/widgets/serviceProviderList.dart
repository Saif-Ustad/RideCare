import 'package:flutter/material.dart';
import 'package:ridecare/presentation/explore/widgets/serviceProviderCard.dart';
import '../../../core/configs/assets/app_images.dart';

class ServiceProviderList extends StatelessWidget {
  const ServiceProviderList({super.key});

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
          children: [
            ServiceProviderCard(
              name: "Bajaj Service Center",
              distance: "0.5 km",
              time: "2 Mins",
              price: "100-1200",
              image: AppImages.popularServiceProvider1,
            ),
            ServiceProviderCard(
              name: "Honda Service Center",
              distance: "1.5 km",
              time: "8 Mins",
              price: "200-1500",
              image: AppImages.popularServiceProvider2,
            ),
            ServiceProviderCard(
              name: "Toyota Service Center",
              distance: "0.5 km",
              time: "2 Mins",
              price: "500-2300",
              image: AppImages.popularServiceProvider3,
            ),
          ],
        ),
      ),
    );
  }
}
