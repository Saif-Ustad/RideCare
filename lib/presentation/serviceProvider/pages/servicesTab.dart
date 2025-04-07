import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridecare/domain/entities/service_entity.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../bloc/service_bloc.dart';
import '../bloc/service_state.dart';

class ServicesTab extends StatelessWidget {
  // final List<Map<String, dynamic>> services = [
  //   {"icon": Icons.oil_barrel, "name": "Engine Oil Change"},
  //   {"icon": Icons.local_car_wash, "name": "Car Wash"},
  //   {"icon": Icons.car_repair, "name": "Scratch Removal"},
  //   {"icon": Icons.oil_barrel, "name": "Engine Oil Change"},
  //   {"icon": Icons.local_car_wash, "name": "Car Wash"},
  //   {"icon": Icons.car_repair, "name": "Scratch Removal"},
  // ];

  const ServicesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceBloc, ServiceState>(
      builder: (context, state) {
        if (state is ServiceLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ServiceLoaded) {
          final services = state.services;

          if (services.isEmpty) {
            return const Center(child: Text('No services available.'));
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Services",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 12),

                Column(
                  children:
                      services.map((service) => _serviceItem(service)).toList(),
                ),
              ],
            ),
          );
        } else if (state is ServiceError) {
          return Center(child: Text(state.message));
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _serviceItem(ServiceEntity service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.15),
            ),
            // child: Icon(service.iconUrl, size: 24, color: AppColors.primary),
            child: CachedNetworkImage(
              imageUrl: service.iconUrl,
              width: 24,
              height: 24,
              placeholder:
                  (context, url) => Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              errorWidget:
                  (context, url, error) => const Icon(
                    Icons.broken_image,
                    size: 24,
                    color: Colors.redAccent,
                  ),
            ),
          ),
          const SizedBox(width: 12),

          // Service Name
          Text(
            service.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
