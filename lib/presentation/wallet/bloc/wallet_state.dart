import 'package:equatable/equatable.dart';
import '../../../domain/entities/wallet_transaction_entity.dart';

abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final double balance;
  final List<WalletTransactionEntity> transactions;

  const WalletLoaded({required this.balance, required this.transactions});

  @override
  List<Object?> get props => [balance, transactions];
}

class WalletError extends WalletState {
  final String message;

  const WalletError(this.message);

  @override
  List<Object?> get props => [message];
}
