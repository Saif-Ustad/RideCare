import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../bloc/password_toggle_bloc.dart';
import '../bloc/password_toggle_event.dart';
import '../bloc/password_toggle_state.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({super.key, required this.placeHolder,  this.controller});

  final String placeHolder;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordToggleBloc, PasswordToggleState>(
      builder: (context, state) {
        return SizedBox(
          height: 46,
          child: TextField(
            controller: controller,
            obscureText: !state.isPasswordVisible,
            style: const TextStyle(fontSize: 14, height: 1.0),
            decoration: InputDecoration(
              labelText: placeHolder,
              labelStyle: TextStyle(color: AppColors.darkGrey, fontSize: 14),
              prefixIcon: Icon(Icons.lock, color: AppColors.darkGrey),
              suffixIcon: IconButton(
                icon: Icon(
                  state.isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: AppColors.darkGrey,
                ),
                onPressed: () {
                  context.read<PasswordToggleBloc>().add(TogglePasswordVisibility());
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.darkGrey),
              ),
            ),
          ),
        );
      },
    );
  }
}
