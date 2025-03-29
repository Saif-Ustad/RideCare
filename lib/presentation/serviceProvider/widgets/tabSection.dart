
import 'package:flutter/material.dart';

import '../../../core/configs/theme/app_colors.dart';

class TabSection extends StatelessWidget {
  final TabController tabController;

  const TabSection({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      labelColor: AppColors.primary,
      unselectedLabelColor: Colors.grey,
      indicatorColor: AppColors.primary,
      labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      tabs: const [
        Tab(text: 'About'),
        Tab(text: 'Services'),
        Tab(text: 'Gallery'),
        Tab(text: 'Review'),
      ],
    );
  }
}
