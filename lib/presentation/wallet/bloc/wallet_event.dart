import 'package:equatable/equatable.dart';

import '../../../domain/entities/wallet_transaction_entity.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

class LoadWalletBalance extends WalletEvent {
  final String uid;

  const LoadWalletBalance(this.uid);

  @override
  List<Object?> get props => [uid];
}

class LoadWalletTransactions extends WalletEvent {
  final String uid;

  const LoadWalletTransactions(this.uid);

  @override
  List<Object?> get props => [uid];
}

class AddWalletTransaction extends WalletEvent {
  final String uid;
  final WalletTransactionEntity transaction;

  const AddWalletTransaction(this.uid, this.transaction);

  @override
  List<Object?> get props => [uid, transaction];
}

class WalletTransactionsUpdated extends WalletEvent {
  final String uid;
  final List<WalletTransactionEntity> transactions;

  const WalletTransactionsUpdated({
    required this.uid,
    required this.transactions,
  });

  @override
  List<Object?> get props => [uid, transactions];
}

class AddMoneyToWallet extends WalletEvent {
  final String uid;
  final double amount;

  const AddMoneyToWallet({required this.uid, required this.amount});

  @override
  List<Object> get props => [uid, amount];
}
