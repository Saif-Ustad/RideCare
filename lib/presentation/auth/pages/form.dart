import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridecare/common/widgets/button/squareButton.dart';
import 'package:ridecare/core/configs/theme/app_colors.dart';
import 'package:ridecare/presentation/auth/bloc/auth_bloc.dart';
import 'package:ridecare/presentation/auth/pages/signin.dart';
import 'package:ridecare/presentation/auth/widgets/general_text_field.dart';
import 'package:ridecare/presentation/auth/widgets/password_field.dart';

import '../../../core/dependency_injection/service_locator.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart'; // Import Service Locator

class UserFormPage extends StatefulWidget {
  const UserFormPage({super.key});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isChecked = false; // Checkbox state

  void _signIn() {
    final String firstName = _firstNameController.text.trim();
    final String lastName = _lastNameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields.")),
      );
      return;
    }

    sl<AuthBloc>().add(RegisterEvent(firstName, lastName, email, password));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Fill out this form",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: AppColors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
          
                const SizedBox(height: 10),
          
                const Text(
                  "Please complete your information.",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: AppColors.darkGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
          
                const SizedBox(height: 40),
          
                GeneralTextField(placeholder: "First Name", controller: _firstNameController,),
          
                const SizedBox(height: 15),
          
                GeneralTextField(placeholder: "Last Name", controller: _lastNameController,),
          
                const SizedBox(height: 15),
          
                GeneralTextField(
                  placeholder: "Email",
                  icon: Icons.email,
                  controller: _emailController,
                ),
          
                const SizedBox(height: 15),
          
                PasswordField(
                  placeHolder: "Password",
                  controller: _passwordController,
                ),
          
                const SizedBox(height: 15),
          
                Row(
                  children: [
                    Checkbox(
                      value: _isChecked,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _isChecked = newValue!;
                        });
                      },
                    ),
          
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.darkGrey,
                            fontSize: 14,
                          ),
                          children: [
                            const TextSpan(
                              text: "By creating an account you agree to our ",
                            ),
                            TextSpan(
                              text: "Terms.",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => const UserFormPage(),
                                        ),
                                      );
                                    },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
          
                const SizedBox(height: 15),
          
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return BlocListener<AuthBloc, AuthState>(
                      bloc: sl<AuthBloc>(),
                      listener: (context, state) {
                        if (state is Unauthenticated) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Sign-Up successful!")),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInPage(),
                            ),
                          );
                        } else if (state is AuthError) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(state.message)));
                        }
                      },
                      child: SquareButton(
                        onPressed:
                            (state is AuthLoading || !_isChecked)
                                ? null
                                : _signIn,
                        buttonText: "Sign Up",
                        isLoading: state is AuthLoading,
                      ),
                    );
                  },
                ),
          
                SizedBox(height: 40),
          
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: AppColors.darkGrey,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Sign in",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
