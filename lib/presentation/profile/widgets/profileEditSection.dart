import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ridecare/domain/entities/user_entity.dart';
import '../../../core/configs/theme/app_colors.dart';

class ProfileSection extends StatelessWidget {
  final UserEntity user;

  const ProfileSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade300,
              backgroundImage:
                  (user.userProfileImageUrl != null &&
                          user.userProfileImageUrl!.isNotEmpty)
                      ? CachedNetworkImageProvider(user.userProfileImageUrl!)
                      : null,
              child:
                  (user.userProfileImageUrl == null ||
                          user.userProfileImageUrl!.isEmpty)
                      ? Text(
                        user.firstName != null && user.firstName!.isNotEmpty
                            ? user.firstName![0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      )
                      : null,
            ),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit, color: Colors.white, size: 16),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          "${user.firstName} ${user.lastName}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
