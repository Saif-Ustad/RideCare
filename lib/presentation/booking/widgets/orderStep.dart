import 'package:flutter/material.dart';

import '../../../core/configs/theme/app_colors.dart';

class OrderStep extends StatelessWidget {
  final String title;
  final String time;
  final bool isCompleted;

  const OrderStep({
    required this.title,
    required this.time,
    required this.isCompleted,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.primary : AppColors.darkGrey,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCompleted ? Icons.check : Icons.circle,
                size: 16,
                color: Colors.white,
              ),
            ),
            if (title != "Delivered")
              Container(
                width: 4,
                height: 45,
                color: isCompleted ? AppColors.primary : AppColors.darkGrey,
              ),
          ],
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isCompleted ? AppColors.black : AppColors.darkGrey,
              ),
            ),
            Text(time, style: TextStyle(fontSize: 14, color: AppColors.darkGrey)),
            const SizedBox(height: 20),
          ],
        ),
      ],
    );
  }
}
