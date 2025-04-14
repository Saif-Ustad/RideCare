import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ridecare/common/widgets/bottomBar/bottomBar.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../home/bloc/user/user_bloc.dart';
import '../../home/bloc/user/user_state.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';

class CancelBookingPage extends StatefulWidget {
  final String bookingId;

  const CancelBookingPage({super.key, required this.bookingId});

  @override
  _CancelBookingPageState createState() => _CancelBookingPageState();
}

class _CancelBookingPageState extends State<CancelBookingPage> {
  String _selectedReason = "Change in Plans";
  final TextEditingController _otherReasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _buildLeadingIconButton(() => context.pop()),
        title: const Text(
          "Cancel Booking",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Please Select the reason for cancellations:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 5),
              // Radio buttons
              _buildRadioOption("Change in Plans."),
              _buildRadioOption("Vehicle Issues."),
              _buildRadioOption("Unexpected Work."),
              _buildRadioOption("Unexpected Commitments."),
              _buildRadioOption("Personal Reasons."),
              _buildRadioOption("Other"),

              // TextField for "Other" option
              if (_selectedReason == "Other") ...[
                const SizedBox(height: 10),
                const Text("Other.", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 5),
                TextField(
                  controller: _otherReasonController,
                  decoration: InputDecoration(
                    hintText: "Enter Your Reason",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: AppColors.lightGray,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        text: "Cancel Booking",
        onPressed: () {
          final currentUser =
              (context.read<UserBloc>().state as UserLoaded).user;

          context.read<BookingBloc>().add(
            CancelBooking(bookingId: widget.bookingId, userId: currentUser.uid),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Booking cancelled successfully')),
          );

          context.pop();
        },
      ),
    );
  }

  Widget _buildLeadingIconButton(VoidCallback onPressed) => Padding(
    padding: const EdgeInsets.only(left: 15),
    child: Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.darkGrey, width: 1),
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
        onPressed: onPressed,
      ),
    ),
  );

  Widget _buildRadioOption(String reason) {
    return RadioListTile<String>(
      title: Text(reason),
      value: reason,
      groupValue: _selectedReason,
      onChanged: (value) {
        setState(() {
          _selectedReason = value!;
        });
      },
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}
