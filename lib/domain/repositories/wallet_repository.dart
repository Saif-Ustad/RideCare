import '../entities/wallet_transaction_entity.dart';

abstract class WalletRepository {
  Future<double> getWalletBalance(String uid);

  Stream<List<WalletTransactionEntity>> getTransactions(String uid);

  Future<void> addTransaction(String uid, WalletTransactionEntity transaction);

  Future<void> addMoneyToWallet(String uid, double amount);
}
