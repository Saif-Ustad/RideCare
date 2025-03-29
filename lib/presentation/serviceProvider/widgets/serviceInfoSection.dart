
import 'package:flutter/material.dart';

import '../../../core/configs/theme/app_colors.dart';

class ServiceInfoSection extends StatelessWidget {
  const ServiceInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.lightGray,
                ),
                child: Text(
                  'Car Service',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.star, color: Colors.amber, size: 18),
              const SizedBox(width: 5),
              const Text('4.8 (365 reviews)', style: TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bajaj Service Center',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '1023, Kondhwa bk, Pune',
                      style: TextStyle(color: AppColors.darkGrey, fontSize: 14),
                    ),
                  ],
                ),
              ),
              Icon(Icons.telegram, size: 45, color: AppColors.primary),
            ],
          ),
        ],
      ),
    );
  }
}
