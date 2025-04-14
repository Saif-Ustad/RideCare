// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:ridecare/common/widgets/button/squareButton.dart';
// import 'package:ridecare/core/configs/assets/app_vectors.dart';
// import 'package:ridecare/presentation/auth/pages/form.dart';
// import 'package:ridecare/presentation/auth/widgets/otp_text_field.dart';
// import 'package:ridecare/presentation/splash/pages/splash.dart';
//
// import '../../../core/configs/theme/app_colors.dart';
// import '../bloc/otp_bloc.dart';
// import '../bloc/otp_event.dart';
// import '../bloc/otp_state.dart';
// import '../widgets/auth_banner.dart';
//
// class VerifyPage extends StatelessWidget {
//   const VerifyPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 AuthBanner(
//                   image: AppVectors.authBanner3,
//                   title: "Verify your number",
//                   subTitle:
//                       "We sent you a 6-digit code to verify \n your number",
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 // // OTP Input Field
//                 // OtpTextField(length: 6),
//
//                 PinCodeTextField(
//                   appContext: context,
//                   length: 6,
//                   obscureText: false,
//                   animationType: AnimationType.scale,
//                   keyboardType: TextInputType.number,
//                   textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.black),
//                   pinTheme: PinTheme(
//                     shape: PinCodeFieldShape.box,
//                     borderRadius: BorderRadius.circular(10),
//                     fieldHeight: 50,
//                     fieldWidth: 50,
//                     activeFillColor: Colors.white,
//                     inactiveFillColor: Colors.white,
//                     selectedFillColor: Colors.blue[100],
//                     inactiveColor: AppColors.grey, // Border color when inactive
//                     selectedColor: Colors.blue, // Border color when selected
//                     activeColor: Colors.blueAccent, // Border color when active
//                   ),
//                   enableActiveFill: true, // Enables background fill for active field
//                   onCompleted: (otp) {
//                     print("OTP entered: $otp");
//                   },
//                 ),
//
//                 const SizedBox(height: 10),
//
//                 BlocListener<OtpBloc, OtpState>(
//                   listener: (context, state) {
//                     if (state is OtpSuccess) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const UserFormPage(),
//                         ),
//                       ); // Navigate to HomePage
//                     } else if (state is OtpFailure) {
//                       ScaffoldMessenger.of(
//                         context,
//                       ).showSnackBar(SnackBar(content: Text(state.error)));
//                     }
//                   },
//                   child: BlocBuilder<OtpBloc, OtpState>(
//                     builder: (context, state) {
//                       return Column(
//                         children: [
//                           if (state is OtpInvalid)
//                             const Padding(
//                               padding: EdgeInsets.only(top: 8.0),
//                               child: Text(
//                                 "Please enter a valid OTP",
//                                 style: TextStyle(color: Colors.red),
//                               ),
//                             ),
//
//                           // const SizedBox(height: 20),
//
//                           SquareButton(
//                             onPressed: () => {},
//                                 // (state is OtpValid)
//                                 //     ? () =>
//                                 //         context.read<OtpBloc>().add(SubmitOtp())
//                                 //     : null,
//                             buttonText: "Verify",
//                             isLoading: state is OtpSubmitting,
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//
//                 const SizedBox(height: 40),
//
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       "Didn’t receive the code?",
//                       style: TextStyle(
//                         fontWeight: FontWeight.w400,
//                         fontSize: 16,
//                         color: AppColors.darkGrey,
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const VerifyPage(),
//                           ),
//                         );
//                       },
//                       child: const Text(
//                         "Resend",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:ridecare/common/widgets/button/squareButton.dart';
import 'package:ridecare/core/configs/assets/app_vectors.dart';
import 'package:ridecare/presentation/auth/pages/form.dart';
import 'package:ridecare/presentation/splash/pages/splash.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../bloc/otp_bloc.dart';
import '../bloc/otp_event.dart';
import '../bloc/otp_state.dart';
import '../widgets/auth_banner.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({super.key});

  @override
  _VerifyPageState createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  String enteredOtp = ""; // Store OTP value

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AuthBanner(
                  image: AppVectors.authBanner3,
                  title: "Verify your number",
                  subTitle:
                  "We sent you a 6-digit code to verify \n your number",
                ),

                const SizedBox(height: 20),

                // OTP Input Field
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.scale,
                  keyboardType: TextInputType.number,
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10),
                    fieldHeight: 50,
                    fieldWidth: 50,
                    activeFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    selectedFillColor: Colors.blue[100],
                    inactiveColor: AppColors.grey, // Border color when inactive
                    selectedColor: Colors.blue, // Border color when selected
                    activeColor: Colors.blueAccent, // Border color when active
                  ),
                  enableActiveFill: true,
                  onChanged: (value) {
                    setState(() {
                      enteredOtp = value; // Update OTP value
                    });
                  },
                  onCompleted: (otp) {
                    setState(() {
                      enteredOtp = otp; // Ensure OTP is stored on completion
                    });
                  },
                ),

                const SizedBox(height: 10),

                BlocListener<OtpBloc, OtpState>(
                  listener: (context, state) {
                    if (state is OtpSuccess) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserFormPage(),
                        ),
                      );
                    } else if (state is OtpFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error)),
                      );
                    }
                  },
                  child: BlocBuilder<OtpBloc, OtpState>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          if (state is OtpInvalid)
                            const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(
                                "Please enter a valid OTP",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),

                          const SizedBox(height: 20),

                          SquareButton(
                            onPressed: enteredOtp.length == 6
                                ? () => context.read<OtpBloc>().add(SubmitOtp(enteredOtp))
                                : null, // Button disabled until OTP is complete
                            buttonText: "Verify",
                            isLoading: state is OtpSubmitting,
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 40),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Didn’t receive the code?",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: AppColors.darkGrey,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<OtpBloc>().add(ResendOtp());
                      },
                      child: const Text(
                        "Resend",
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
