
import 'package:flutter/material.dart';
import 'package:vector_graphics/vector_graphics.dart';

import '../../../core/configs/theme/app_colors.dart';

class OnBoardingBanner extends StatelessWidget {
  const OnBoardingBanner({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  final String image, title, subtitle;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Center(
      child: SizedBox(
        height: screenSize.height * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            VectorGraphic(
              loader: AssetBytesLoader(image),
              width: screenSize.width * 0.6,
              height: screenSize.height * 0.3,
            ),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: 20),
            Text(
              subtitle,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: AppColors.darkGrey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
