import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widgets/bottomBar/bottomBar.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/wallet_transaction_entity.dart';
import '../../booking/bloc/booking_bloc.dart';
import '../../booking/bloc/booking_event.dart';
import '../../booking/bloc/booking_state.dart';
import '../../home/bloc/user/user_bloc.dart';
import '../../home/bloc/user/user_state.dart';
import '../../wallet/bloc/wallet_bloc.dart';
import '../../wallet/bloc/wallet_event.dart';
import '../../wallet/bloc/wallet_state.dart';
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
  double walletBalance = 0;

  @override
  void initState() {
    super.initState();

    final userState = context.read<UserBloc>().state;
    if (userState is UserLoaded) {
      context.read<WalletBloc>().add(LoadWalletBalance(userState.user.uid));
    }
  }

  void _onPaymentSelected(String paymentMethod) {
    setState(() {
      _selectedPayment = paymentMethod;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<WalletBloc, WalletState>(
          listener: (context, state) {
            if (state is WalletLoaded) {
              setState(() {
                walletBalance = state.balance;
              });
            } else if (state is WalletError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error: ${state.message}")),
              );
            }
          },
        ),

        BlocListener<PaymentBloc, PaymentState>(
          listener: (context, state) {
            if (state is PaymentSuccess) {
              context.read<BookingBloc>().add(
                SubmitBooking(paymentMode: "Card"),
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Payment Successful")),
              );
            } else if (state is PaymentFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Payment Failed: ${state.error}")),
              );
            }
          },
        ),
        BlocListener<BookingBloc, BookingState>(
          listener: (context, bookingState) {
            if (bookingState is BookingSubmitted) {
              final bookingId = bookingState.bookingId;
              context.push("/payment-done", extra: bookingId);
            } else if (bookingState is BookingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Booking failed. Try again.")),
              );
            }
          },
        ),
      ],
      child: Scaffold(
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
              _buildWalletPaymentOption(),
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
        bottomNavigationBar: CustomBottomBar(
          text: "Continue",
          onPressed: () {
            context.read<BookingBloc>().add(
              SubmitBooking(paymentMode: _selectedPayment),
            );
          },
        ),
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
    final isSelected = _selectedPayment == value;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Material(
        color: isSelected ? AppColors.lightGray : Colors.white,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          splashColor: AppColors.primary.withOpacity(0.2),
          onTap: () => _onPaymentSelected(value),
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.grey.shade300,
                width: isSelected ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(title, style: const TextStyle(fontSize: 14)),
                  ],
                ),
                Radio<String>(
                  value: value,
                  groupValue: _selectedPayment,
                  onChanged:
                      (String? newValue) => _onPaymentSelected(newValue!),
                  activeColor: AppColors.primary,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardPaymentOption(String title, IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          splashColor: AppColors.primary.withOpacity(0.1),
          onTap: () {
            final userState = context.read<UserBloc>().state;

            if (userState is UserLoaded) {
              final user = userState.user;

              final String name = '${user.firstName} ${user.lastName}';
              final String email = user.email!;

              context.read<PaymentBloc>().add(
                StartPayment(name: name, email: email, amount: widget.amount),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('User not loaded. Please log in.'),
                ),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
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
                    const SizedBox(width: 8),
                    Text(title, style: const TextStyle(fontSize: 14)),
                  ],
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.darkGrey,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWalletPaymentOption() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Material(
        color:
            _selectedPayment == "Wallet" ? AppColors.lightGray : Colors.white,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          splashColor: AppColors.primary.withOpacity(0.2),
          onTap: () {
            if (walletBalance >= widget.amount) {
              _showConfirmationDialog();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Insufficient wallet balance")),
              );
            }
          },
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color:
                    _selectedPayment == "Wallet"
                        ? AppColors.primary
                        : Colors.grey.shade300,
                width: _selectedPayment == "Wallet" ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.wallet, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Text("Wallet", style: const TextStyle(fontSize: 14)),
                  ],
                ),
                Text("₹$walletBalance", style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Confirm Payment"),
          content: Text(
            "Are you sure you want to proceed with the payment of ₹${widget.amount} using your wallet balance?",
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                final userState = context.read<UserBloc>().state;
                if (userState is UserLoaded) {
                  final uid = userState.user.uid;
                  final transaction = WalletTransactionEntity(
                    title: "Payment for Booking",
                    amount: widget.amount,
                    timestamp: DateTime.now(),
                    balanceAfter: walletBalance - widget.amount,
                    isCredit: false,
                  );

                  context.read<WalletBloc>().add(
                    AddWalletTransaction(uid, transaction),
                  );
                }

                context.read<BookingBloc>().add(
                  SubmitBooking(paymentMode: "Wallet"),
                );

                context.pop();
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }
}
