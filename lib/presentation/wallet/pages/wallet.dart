import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ridecare/domain/entities/wallet_transaction_entity.dart';
import 'package:ridecare/presentation/home/bloc/user/user_bloc.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../home/bloc/user/user_state.dart';
import '../bloc/wallet_bloc.dart';
import '../bloc/wallet_event.dart';
import '../bloc/wallet_state.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  bool showCredits = true;
  bool showDebits = true;

  @override
  Widget build(BuildContext context) {
    final walletBloc = context.read<WalletBloc>();
    final userState = context.watch<UserBloc>().state;

    if (userState is UserLoaded) {
      final user = userState.user;
      walletBloc.add(LoadWalletTransactions(user.uid));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: BlocBuilder<WalletBloc, WalletState>(
              builder: (context, state) {
                if (state is WalletLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is WalletLoaded) {
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildWalletCard(context, state.balance),
                      const SizedBox(height: 24),
                      if (state.transactions.isNotEmpty)
                        ..._buildGroupedTransactions(state.transactions),
                    ],
                  );
                } else if (state is WalletError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: _buildLeadingIconButton(() => context.pop()),
      title: const Text(
        "Wallet",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildWalletCard(BuildContext context, double balance) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6D5DF6), Color(0xFF9E79F2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Wallet Balance",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "₹ ${balance.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton.icon(
              onPressed: () => context.push("/add-money-wallet"),
              icon: const Icon(
                Icons.add_circle_outline,
                size: 20,
                color: Colors.white,
              ),
              label: const Text("Add Money"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildGroupedTransactions(
    List<WalletTransactionEntity> transactions,
  ) {
    final grouped = <String, List<WalletTransactionEntity>>{};

    // Apply filters first
    final filteredTransactions =
        transactions.where((txn) {
          if (txn.isCredit && showCredits) return true;
          if (!txn.isCredit && showDebits) return true;
          return false;
        }).toList();

    // Group filtered transactions by date
    for (final txn in filteredTransactions) {
      final dateStr = _formatDate(txn.timestamp);
      grouped.putIfAbsent(dateStr, () => []).add(txn);
    }

    final List<Widget> widgets = [];
    grouped.forEach((date, txns) {
      widgets.add(_buildSection(date));
      widgets.addAll(
        txns.map(
          (txn) => _buildTransactionTile(
            txn.title,
            txn.isCredit ? "+\₹${txn.amount}" : "-\₹${txn.amount}",
            _formatTime(txn.timestamp),
            "\₹${txn.balanceAfter.toStringAsFixed(2)}",
            txn.isCredit,
          ),
        ),
      );
      widgets.add(const SizedBox(height: 16));
    });

    return widgets;
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.darkGrey,
        ),
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
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: AppColors.lightGray),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon for credit/debit
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCredit ? Colors.green.shade50 : Colors.red.shade50,
            ),
            child: Icon(
              isCredit ? Icons.arrow_downward : Icons.arrow_upward,
              size: 18,
              color: isCredit ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(width: 14),

          // Main content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  dateTime,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.darkGrey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Balance: $balance",
                  style: const TextStyle(fontSize: 12, color: Colors.black45),
                ),
              ],
            ),
          ),

          // Amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                isCredit ? amount : amount,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isCredit ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(
      timestamp.year,
      timestamp.month,
      timestamp.day,
    );

    if (dateToCheck == today) {
      return "Today";
    } else if (dateToCheck == yesterday) {
      return "Yesterday";
    }

    return "${timestamp.day.toString().padLeft(2, '0')} "
        "${_monthName(timestamp.month)} ${timestamp.year}";
  }

  String _formatTime(DateTime timestamp) {
    return "${timestamp.day.toString().padLeft(2, '0')} "
        "${_monthName(timestamp.month)} | "
        "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}";
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
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

  // Filter options for credit and debit transactions
  Widget _buildFilters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FilterOption(
          label: "Credits",
          isSelected: showCredits,
          onTap: () {
            setState(() {
              showCredits = !showCredits;
            });
          },
        ),
        const SizedBox(width: 20),
        FilterOption(
          label: "Debits",
          isSelected: showDebits,
          onTap: () {
            setState(() {
              showDebits = !showDebits;
            });
          },
        ),
      ],
    );
  }
}

class FilterOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterOption({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            isSelected ? Icons.check_circle : Icons.check_circle_outline,
            color: isSelected ? Colors.blue : Colors.grey,
            size: 18,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
