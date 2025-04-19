import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/configs/theme/app_colors.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildWalletCard(context),
          const SizedBox(height: 24),
          _buildSection("Today"),
          _buildTransactionTile(
            "Money Added to Wallet",
            "+\$500.00",
            "02 January | 7:30 AM",
            "\$12,000.00",
            true,
          ),
          const SizedBox(height: 16),
          _buildSection("Yesterday"),
          _buildTransactionTile(
            "Order #CRR0215AB3",
            "-\$500.00",
            "01 January | 5:30 AM",
            "\$11,250.00",
            false,
          ),
          const SizedBox(height: 16),
          _buildSection("22 December 2023"),
          _buildTransactionTile(
            "Refund for Order #CRR0215AA3",
            "+\$500.00",
            "22 December | 7:30 AM",
            "\$11,250.00",
            true,
          ),
          _buildTransactionTile(
            "Order #CRR0215AB3",
            "-\$250.00",
            "22 December | 7:30 AM",
            "\$11,250.00",
            false,
          ),
          _buildTransactionTile(
            "Order #CRR0215AB3",
            "-\$250.00",
            "22 December | 7:30 AM",
            "\$11,250.00",
            false,
          ),
          _buildTransactionTile(
            "Order #CRR0215AB3",
            "-\$250.00",
            "22 December | 7:30 AM",
            "\$11,250.00",
            false,
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        "Wallet",
        style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
    );
  }

  Widget _buildWalletCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEAFF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Wallet Balance",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkGrey,
                ),
              ),
              Icon(
                Icons.account_balance_wallet_outlined,
                color: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "\$ 12000.00",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              onPressed: () { context.push("/add-money-wallet");},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Add Money",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.darkGrey,
      ),
    );
  }

  Widget _buildTransactionTile(
    String title,
    String amount,
    String dateTime,
    String balance,
    bool isCredit,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGray),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withOpacity(0.02),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateTime,
                style: const TextStyle(color: AppColors.darkGrey, fontSize: 13),
              ),
              Text(
                amount,
                style: TextStyle(
                  color: isCredit ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "Balance $balance",
            style: const TextStyle(fontSize: 12, color: AppColors.darkGrey),
          ),
        ],
      ),
    );
  }
}
