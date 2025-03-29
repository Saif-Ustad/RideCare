import 'package:flutter/material.dart';

import '../../../core/configs/theme/app_colors.dart';

class ServicesTab extends StatelessWidget {
  final List<Map<String, dynamic>> services = [
    {"icon": Icons.oil_barrel, "name": "Engine Oil Change"},
    {"icon": Icons.local_car_wash, "name": "Car Wash"},
    {"icon": Icons.car_repair, "name": "Scratch Removal"},
    {"icon": Icons.oil_barrel, "name": "Engine Oil Change"},
    {"icon": Icons.local_car_wash, "name": "Car Wash"},
    {"icon": Icons.car_repair, "name": "Scratch Removal"},
  ];

  ServicesTab({super.key});

  @override
  Widget build(BuildContext context) {
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
            children: services.map((service) => _serviceItem(service)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _serviceItem(Map<String, dynamic> service) {
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
            child: Icon(service["icon"], size: 24, color: AppColors.primary),
          ),
          const SizedBox(width: 12),

          // Service Name
          Text(
            service["name"],
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
