import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridecare/common/widgets/button/squareButton.dart';
import 'package:ridecare/core/configs/assets/app_vectors.dart';
import 'package:ridecare/presentation/auth/pages/signin.dart';
import 'package:ridecare/presentation/auth/pages/verify.dart';
import 'package:ridecare/presentation/auth/widgets/auth_banner.dart';
import 'package:ridecare/presentation/auth/widgets/general_text_field.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../bloc/otp_bloc.dart';
import '../bloc/otp_state.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final TextEditingController _phoneController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AuthBanner(
                  image: AppVectors.authBanner2,
                  title: "Let’s get started",
                  subTitle:
                      "We will send a verification code \n on your phone number",
                ),

                const SizedBox(height: 20),

                // Phone Number Input Field
                GeneralTextField(
                  placeholder: "Phone Number",
                  controller: _phoneController,
                  icon: Icons.phone,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),

                const SizedBox(height: 16),

                // SquareButton(
                //   onPressed:
                //       () => {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) => const VerifyPage(),
                //           ),
                //         ),
                //       },
                //   buttonText: "Continue",
                // ),


                BlocConsumer<OtpBloc, OtpState>(
                  listener: (context, state) {
                    if (state is OtpSent) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerifyPage(),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return SquareButton(
                      onPressed: state is OtpSending
                          ? null
                          : () {
                        final phoneNumber = _phoneController.text.trim();
                        if (phoneNumber.isNotEmpty) {

                          // context.read<OtpBloc>().add(SendOtp("+919146394986"));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please enter your phone number")),
                          );
                        }
                      },
                      buttonText: state is OtpSending ? "Sending..." : "Continue",
                    );
                  },
                ),


                const SizedBox(height: 40),

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
