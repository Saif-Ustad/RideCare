
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';

class HeaderSection extends StatelessWidget {
  final List<String> images;

  const HeaderSection({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          AppImages.serviceProvider1,
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.3,
          fit: BoxFit.cover,
        ),
        Positioned(
          top: 10,
          left: 10,
          child: _iconButton(Icons.arrow_back, () => context.pop()),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Row(
            children: [
              _iconButton(Icons.share, () => {}),
              const SizedBox(width: 10),
              _iconButton(Icons.bookmark_border, () => {}),
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          left: MediaQuery.of(context).size.width * 0.1,
          right: MediaQuery.of(context).size.width * 0.1,
          child: _buildGalleryThumbnails(),
        ),
      ],
    );
  }

  Widget _buildGalleryThumbnails() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(4),
      height: 50,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length > 5 ? 5 : images.length,
        itemBuilder: (context, index) {
          bool isLastImage = index == 4 && images.length > 5;
          return Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    images[index],
                    width: 55,
                    height: 55,
                    fit: BoxFit.cover,
                  ),
                ),
                if (isLastImage)
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        "+${images.length - 5}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      height: 40,
      width: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.black, size: 20),
        onPressed: onPressed,
      ),
    );
  }
}
