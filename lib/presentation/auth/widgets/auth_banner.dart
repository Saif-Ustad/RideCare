import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ridecare/core/configs/theme/app_colors.dart';

class AuthBanner extends StatelessWidget {
  const AuthBanner({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
  });

  final String image, title, subTitle;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Column(
      children: [
        SvgPicture.asset(
          image,
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
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 10),

        Text(
          subTitle,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: AppColors.darkGrey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
