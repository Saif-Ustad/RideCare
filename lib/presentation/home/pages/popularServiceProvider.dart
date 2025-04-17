import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ridecare/presentation/home/bloc/serviceProvider/service_provider_bloc.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../bookmark/widgets/serviceCard.dart';
import '../bloc/serviceProvider/service_provider_state.dart';

class PopularServiceProviderPage extends StatelessWidget {
  const PopularServiceProviderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceProviderBloc, ServiceProviderState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: _buildLeadingIconButton(() => context.pop()),
            title: const Text(
              "Service Providers",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child:
                    state is ServiceProviderLoaded
                        ? (state.serviceProviders.isEmpty
                            ? const Center(
                              child: Text('No Service Provider found.'),
                            )
                            : ListView.builder(
                              clipBehavior: Clip.none,
                              itemCount: state.serviceProviders.length,
                              itemBuilder:
                                  (context, index) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: ServiceCard(
                                      serviceProvider:
                                          state.serviceProviders[index],
                                    ),
                                  ),
                            ))
                        : state is ServiceProviderLoading
                        ? const Center(child: CircularProgressIndicator())
                        : const Center(child: Text('Something went wrong.')),
              ),
            ],
          ),
        );
      },
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
