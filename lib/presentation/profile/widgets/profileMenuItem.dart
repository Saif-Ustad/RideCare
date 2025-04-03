import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/configs/theme/app_colors.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;

  const ProfileMenuItem({super.key, required this.icon, required this.title, required this.route});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: () {
        context.push(route);
      },
    );
  }
}
