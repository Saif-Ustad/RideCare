import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridecare/presentation/explore/widgets/serviceProviderCard.dart';
import '../../home/bloc/serviceProvider/service_provider_bloc.dart';
import '../../home/bloc/serviceProvider/service_provider_state.dart';

class ServiceProviderList extends StatelessWidget {
  const ServiceProviderList({super.key});

  //
  // final List<ServiceProvider> serviceProviders = [
  //   ServiceProvider(
  //     "1",
  //     "Bajaj Service Center",
  //     "0.5 km",
  //     "2 Mins",
  //     "100-1200",
  //     AppImages.popularServiceProvider1,
  //   ),
  //   ServiceProvider(
  //     "1",
  //     "Honda Service Center",
  //     "1.5 km",
  //     "8 Mins",
  //     "200-1500",
  //     AppImages.popularServiceProvider2,
  //   ),
  //   ServiceProvider(
  //     "1",
  //     "Toyota Service Center",
  //     "0.5 km",
  //     "2 Mins",
  //     "500-2300",
  //     AppImages.popularServiceProvider3,
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceProviderBloc, ServiceProviderState>(
      builder: (context, state) {
        if (state is ServiceProviderLoaded) {
          final serviceProviders = state.providers;

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
                        .map(
                          (provider) => ServiceProviderCard(provider: provider),
                        )
                        .toList(),
              ),
            ),
          );
        } else if (state is ServiceProviderLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ServiceProviderError) {
          return Center(child: Text(state.message));
        } else {
          return const SizedBox(); // Fallback UI for unknown state
        }
      },
    );
  }
}
