class WalletTransactionEntity {
  final String? id;
  final String title;
  final double amount;
  final DateTime timestamp;
  final double balanceAfter;
  final bool isCredit;

  WalletTransactionEntity({
    this.id,
    required this.title,
    required this.amount,
    required this.timestamp,
    required this.balanceAfter,
    required this.isCredit,
  });
}
