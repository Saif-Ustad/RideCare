import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widgets/bottomBar/bottomBar.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../bloc/payment/payment_bloc.dart';
import '../bloc/payment/payment_event.dart';
import '../bloc/payment/payment_state.dart';

class PaymentGatewayPage extends StatefulWidget {
  final double amount;

  const PaymentGatewayPage({super.key, required this.amount});

  @override
  _PaymentGatewayPageState createState() => _PaymentGatewayPageState();
}

class _PaymentGatewayPageState extends State<PaymentGatewayPage> {
  String _selectedPayment = "Cash";

  void _onPaymentSelected(String paymentMethod) {
    setState(() {
      _selectedPayment = paymentMethod;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _buildLeadingIconButton(() => context.pop()),
        title: const Text(
          "Payment Methods",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Cash",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            _buildPaymentOption("Cash", Icons.account_balance_wallet, "Cash"),

            const SizedBox(height: 10),

            const Text(
              "Wallet",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            _buildPaymentOption("Wallet", Icons.wallet, "Wallet"),

            const SizedBox(height: 10),

            const Text(
              "Credit & Debit Card",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            _buildCardPaymentOption(
              "Credit & Debit Card",
              Icons.credit_card,
              "Add Card",
            ),

            const SizedBox(height: 10),

            const Text(
              "More Payment Options",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            _buildPaymentOption("Paypal", Icons.paypal, "Paypal"),
            _buildPaymentOption("Apple Pay", Icons.apple, "Apple Pay"),
            _buildPaymentOption("Google Pay", Icons.payment, "Google Pay"),
          ],
        ),
      ),
      bottomNavigationBar: BlocConsumer<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Payment Successful")));
            context.push("/payment-done");
          } else if (state is PaymentFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Payment Failed: ${state.error}")),
            );
          }
        },
        builder: (context, state) {
          return CustomBottomBar(
            text: "Continue",
            onPressed: () async {
              try {
                User? currentUser = FirebaseAuth.instance.currentUser;

                if (currentUser != null) {
                  DocumentSnapshot userDoc =
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(currentUser.uid)
                          .get();

                  if (userDoc.exists) {
                    String name =
                        '${userDoc['firstName']} ${userDoc['lastName']}';
                    String email = userDoc['email'];

                    context.read<PaymentBloc>().add(
                      StartPayment(
                        name: name,
                        email: email,
                        amount: widget.amount,
                      ),
                    );
                  } else {
                    print('User document not found');
                  }
                } else {
                  print('No user is logged in');
                }
              } catch (e) {
                print('Error fetching user data: $e');
              }
            },
          );
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

  Widget _buildPaymentOption(String title, IconData icon, String value) {
    return GestureDetector(
      onTap: () => _onPaymentSelected(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: AppColors.primary, size: 20),
                  // Smaller icon
                  const SizedBox(width: 8),
                  Text(title, style: const TextStyle(fontSize: 14)),
                  // Smaller text
                ],
              ),
              Radio<String>(
                value: value,
                groupValue: _selectedPayment,
                onChanged: (String? newValue) => _onPaymentSelected(newValue!),
                activeColor: AppColors.primary,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardPaymentOption(String title, IconData icon, String value) {
    return GestureDetector(
      onTap: () {
        // Navigate to Add Card screen
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0), // Reduced padding
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
          // Reduced padding
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(6), // Slightly smaller radius
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: AppColors.primary, size: 20),
                  // Smaller icon
                  const SizedBox(width: 8),
                  Text(title, style: const TextStyle(fontSize: 14)),
                  // Smaller text
                ],
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.darkGrey,
                size: 14,
              ),
              // Smaller arrow
            ],
          ),
        ),
      ),
    );
  }
}
