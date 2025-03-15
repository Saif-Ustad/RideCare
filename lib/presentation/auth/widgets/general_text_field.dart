import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/configs/theme/app_colors.dart';

class GeneralTextField extends StatelessWidget {
  const GeneralTextField({
    super.key,
    required this.placeholder,
    this.icon,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.controller,
  });

  final String placeholder;
  final IconData? icon;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: const TextStyle(fontSize: 14, height: 1.0),
        decoration: InputDecoration(
          labelText: placeholder,
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          labelStyle: TextStyle(color: AppColors.darkGrey, fontSize: 14),
          prefixIcon:
              icon != null ? Icon(icon, color: AppColors.darkGrey) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.darkGrey),
          ),

        ),
      ),
    );
  }
}
