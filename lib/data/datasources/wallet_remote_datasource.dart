import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ridecare/data/models/wallet_transaction_model.dart';

abstract class WalletRemoteDataSource {
  Future<double> getWalletBalance(String uid);

  Stream<List<WalletTransactionModel>> getTransactions(String uid);

  Future<void> addTransaction(String uid, WalletTransactionModel transaction);

  Future<void> addMoneyToWallet(String uid, double amount);
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final FirebaseFirestore firestore;

  WalletRemoteDataSourceImpl({required this.firestore});

  @override
  Future<double> getWalletBalance(String uid) async {
    final snapshot = await firestore.collection('users').doc(uid).get();
    final balance = snapshot.data()?['walletBalance'];
    return (balance is num) ? balance.toDouble() : 0.0;
  }

  @override
  Stream<List<WalletTransactionModel>> getTransactions(String uid) {
    return firestore
        .collection('users')
        .doc(uid)
        .collection('wallet_transactions')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) =>
                        WalletTransactionModel.fromJson(doc.data(), doc.id),
                  )
                  .toList(),
        );
  }

  @override
  Future<void> addTransaction(
    String uid,
    WalletTransactionModel transaction,
  ) async {
    final userRef = firestore.collection('users').doc(uid);
    final walletTransactionRef =
        userRef.collection('wallet_transactions').doc();

    await firestore.runTransaction((txn) async {
      final userSnapshot = await txn.get(userRef);
      final currentBalance = userSnapshot.data()?['walletBalance'] ?? 0.0;

      final newBalance =
          transaction.isCredit
              ? currentBalance + transaction.amount
              : currentBalance - transaction.amount;

      txn.set(walletTransactionRef, {
        'title': transaction.title,
        'amount': transaction.amount,
        'timestamp': transaction.timestamp,
        'balanceAfter': newBalance,
        'isCredit': transaction.isCredit,
      });

      txn.update(userRef, {'walletBalance': newBalance});
    });
  }

  @override
  Future<void> addMoneyToWallet(String uid, double amount) async {
    final userRef = firestore.collection('users').doc(uid);
    final walletTransactionRef =
        userRef.collection('wallet_transactions').doc();

    await firestore.runTransaction((txn) async {
      final userSnapshot = await txn.get(userRef);

      final currentBalance = userSnapshot.data()?['walletBalance'] ?? 0.0;

      final newBalance = currentBalance + amount;

      final transaction = WalletTransactionModel(
        id: walletTransactionRef.id,
        title: 'Money Added to Wallet',
        amount: amount,
        timestamp: Timestamp.now().toDate(),
        balanceAfter: newBalance,
        isCredit: true,
      );

      txn.set(walletTransactionRef, transaction.toJson());

      txn.update(userRef, {'walletBalance': newBalance});
    });
  }
}
