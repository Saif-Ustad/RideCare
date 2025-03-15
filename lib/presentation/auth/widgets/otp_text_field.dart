// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/services.dart';
//
// import '../../../core/configs/theme/app_colors.dart';
// import '../bloc/otp_bloc.dart';
// import '../bloc/otp_event.dart';
// import '../bloc/otp_state.dart';
//
// class OtpTextField extends StatefulWidget {
//   final int length;
//
//   const OtpTextField({super.key, this.length = 5});
//
//   @override
//   State<OtpTextField> createState() => _OtpTextFieldState();
// }
//
// class _OtpTextFieldState extends State<OtpTextField> {
//   late List<TextEditingController> _controllers;
//   late List<FocusNode> _focusNodes;
//
//   @override
//   void initState() {
//     super.initState();
//     _controllers = List.generate(widget.length, (_) => TextEditingController());
//     _focusNodes = List.generate(widget.length, (_) => FocusNode());
//   }
//
//   @override
//   void dispose() {
//     for (var controller in _controllers) {
//       controller.dispose();
//     }
//     for (var focusNode in _focusNodes) {
//       focusNode.dispose();
//     }
//     super.dispose();
//   }
//
//   void _onTextChanged(int index, String value) {
//     if (value.isNotEmpty && index < widget.length - 1) {
//       FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
//     } else if (value.isEmpty && index > 0) {
//       FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
//     }
//
//     String otp = _controllers.map((c) => c.text).join();
//     context.read<OtpBloc>().add(OtpEntered(otp));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<OtpBloc, OtpState>(
//       builder: (context, state) {
//         return Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: List.generate(
//                 widget.length,
//                 (index) => SizedBox(
//                   width: 50,
//                   height: 50,
//                   child: TextFormField(
//                     controller: _controllers[index],
//                     focusNode: _focusNodes[index],
//                     keyboardType: TextInputType.number,
//                     textAlign: TextAlign.center,
//                     maxLength: 1,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       color: AppColors.black,
//                     ),
//                     decoration: InputDecoration(
//                       counterText: "",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: const BorderSide(color: AppColors.grey),
//                       ),
//                     ),
//                     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                     onChanged: (value) => _onTextChanged(index, value),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../bloc/otp_bloc.dart';
import '../bloc/otp_event.dart';
import '../bloc/otp_state.dart';

class OtpTextField extends StatefulWidget {
  final int length;

  const OtpTextField({super.key, this.length = 5});

  @override
  State<OtpTextField> createState() => _OtpTextFieldState();
}

class _OtpTextFieldState extends State<OtpTextField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onTextChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < widget.length - 1) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      }
    } else if (index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }

    String otp = _controllers.map((c) => c.text).join();

    if (otp.length == widget.length) {
      context.read<OtpBloc>().add(SubmitOtp(otp));
    }
  }

  void _clearOtpFields() {
    for (var controller in _controllers) {
      controller.clear();
    }
    FocusScope.of(context).requestFocus(_focusNodes[0]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OtpBloc, OtpState>(
      listener: (context, state) {
        if (state is OtpFailure || state is OtpInvalid) {
          _clearOtpFields();
        }
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              widget.length,
              (index) => SizedBox(
                width: 50,
                height: 50,
                child: TextFormField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                  decoration: InputDecoration(
                    counterText: "",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.grey),
                    ),
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) => _onTextChanged(index, value),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
