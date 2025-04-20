import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../home/bloc/user/user_bloc.dart';
import '../../home/bloc/user/user_state.dart';
import '../bloc/wallet_bloc.dart';
import '../bloc/wallet_event.dart';
import '../bloc/wallet_state.dart';

class AddMoneyWalletPage extends StatefulWidget {
  const AddMoneyWalletPage({super.key});

  @override
  State<AddMoneyWalletPage> createState() => _AddMoneyWalletPageState();
}

class _AddMoneyWalletPageState extends State<AddMoneyWalletPage> {
  final TextEditingController _amountController = TextEditingController();

  final List<String> _presetAmounts = [
    "100",
    "200",
    "500",
    "1000",
    "2000",
    "3000",
    "4000",
    "5000",
  ];

  void _appendAmount(String amount) {
    final current = double.tryParse(_amountController.text) ?? 0;
    final newAmount = current + double.parse(amount);
    setState(() {
      _amountController.text = newAmount.toStringAsFixed(2);
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
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
          "Add Money",
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
        child: BlocConsumer<WalletBloc, WalletState>(
          listener: (context, state) {
            if (state is WalletError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is WalletLoaded) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Added \₹${_amountController.text} to wallet!"),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is WalletLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWalletCard(state),
                const SizedBox(height: 24),
                const Text(
                  "Select Amount",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                _buildAmountButtons(),
                const SizedBox(height: 20),
                _buildTextField(),
                const SizedBox(height: 24),
                _buildAddMoneyButton(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildWalletCard(WalletState state) {
    String balance = '0.00';
    if (state is WalletLoaded) {
      balance = state.balance.toStringAsFixed(2);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6D5DF6), Color(0xFF9E79F2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Wallet Balance",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                "\₹ $balance",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Icon(
            Icons.account_balance_wallet_outlined,
            color: Colors.white,
            size: 32,
          ),
        ],
      ),
    );
  }

  Widget _buildAmountButtons() {
    return GridView.builder(
      itemCount: _presetAmounts.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.3,
      ),
      itemBuilder: (context, index) {
        final amount = _presetAmounts[index];
        return GestureDetector(
          onTap: () => _appendAmount(amount),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              "+₹$amount",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _amountController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        prefixText: "\₹ ",
        hintText: "Enter Custom Amount",
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: const Color(0xFFF0F0F0),
      ),
    );
  }

  Widget _buildAddMoneyButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          final amount = double.tryParse(_amountController.text) ?? 0;
          final userState = context.read<UserBloc>().state;

          if (amount > 0) {
            final uid = (userState is UserLoaded) ? userState.user.uid : null;

            if (uid != null) {
              context.read<WalletBloc>().add(
                AddMoneyToWallet(uid: uid, amount: amount),
              );
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("User not found")));
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please enter a valid amount")),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 6,
        ),
        child: const Text(
          "Add Money",
          style: TextStyle(color: Colors.white, fontSize: 16),
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
        color: Colors.white,
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
        onPressed: onPressed,
        constraints: const BoxConstraints(),
        padding: EdgeInsets.zero,
      ),
    ),
  );
}
