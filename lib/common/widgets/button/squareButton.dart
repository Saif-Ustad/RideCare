import 'package:flutter/material.dart';

import '../../../core/configs/theme/app_colors.dart';

class SquareButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String buttonText;
  final bool isLoading;

  const SquareButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Full width
      height: 45, // Adjust height as needed
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child:
            isLoading
                ? Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
                : Text(
                  buttonText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
      ),
    );
  }
}
