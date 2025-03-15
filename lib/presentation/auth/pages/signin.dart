import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridecare/core/configs/assets/app_vectors.dart';
import 'package:ridecare/core/configs/theme/app_colors.dart';
import 'package:ridecare/presentation/auth/bloc/auth_bloc.dart';
import 'package:ridecare/presentation/auth/bloc/auth_event.dart';
import 'package:ridecare/presentation/auth/bloc/auth_state.dart';
import 'package:ridecare/presentation/auth/pages/form.dart';
import 'package:ridecare/presentation/home/pages/home.dart';
import '../widgets/auth_banner.dart';
import '../widgets/general_text_field.dart';
import '../widgets/password_field.dart';
import '../../../common/widgets/button/squareButton.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Login Successful!")));

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AuthBanner(
                    image: AppVectors.authBanner1,
                    title: "Welcome Back!",
                    subTitle: "Please login to your account.",
                  ),
                  const SizedBox(height: 20),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        GeneralTextField(
                          controller: _emailController,
                          placeholder: "Email",
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 10),

                        PasswordField(
                          controller: _passwordController,
                          placeHolder: "Password",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          // TODO: Navigate to Forgot Password Page
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: AppColors.primary,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return SquareButton(
                        onPressed:
                            state is AuthLoading
                                ? null
                                : () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthBloc>().add(
                                      LoginEvent(
                                        _emailController.text.trim(),
                                        _passwordController.text.trim(),
                                      ),
                                    );
                                  }
                                },
                        buttonText: "Sign in",
                        isLoading: state is AuthLoading,
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
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
                              builder: (context) => const UserFormPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Sign Up",
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
      ),
    );
  }
}
