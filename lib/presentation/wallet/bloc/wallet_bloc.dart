import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/wallet_transaction_entity.dart';
import '../../../domain/usecases/wallet/add_money_to_wallet_usecase.dart';
import '../../../domain/usecases/wallet/add_transaction_usecase.dart';
import '../../../domain/usecases/wallet/get_transactions_usecase.dart';
import '../../../domain/usecases/wallet/get_wallet_balance_usecase.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetWalletBalanceUseCase getBalanceUseCase;
  final GetWalletTransactionsUseCase getTransactionsUseCase;
  final AddWalletTransactionUseCase addTransactionUseCase;
  final AddMoneyToWalletUseCase addMoneyToWalletUseCase;

  StreamSubscription<List<WalletTransactionEntity>>? _transactionSub;

  WalletBloc({
    required this.getBalanceUseCase,
    required this.getTransactionsUseCase,
    required this.addTransactionUseCase,
    required this.addMoneyToWalletUseCase,
  }) : super(WalletInitial()) {
    on<LoadWalletBalance>(_onLoadWalletBalance);
    on<LoadWalletTransactions>(_onLoadWalletTransactions);
    on<WalletTransactionsUpdated>(_onWalletTransactionsUpdated);
    on<AddWalletTransaction>(_onAddTransaction);
    on<AddMoneyToWallet>(_onAddMoneyToWallet);
  }

  Future<void> _onLoadWalletBalance(
    LoadWalletBalance event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletLoading());
    try {
      final balance = await getBalanceUseCase(event.uid);
      emit(WalletLoaded(balance: balance, transactions: []));
    } catch (e) {
      emit(WalletError('Failed to load wallet balance'));
    }
  }

  Future<void> _onLoadWalletTransactions(
    LoadWalletTransactions event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletLoading());

    await _transactionSub?.cancel();

    _transactionSub = getTransactionsUseCase(event.uid).listen((transactions) {
      add(
        WalletTransactionsUpdated(uid: event.uid, transactions: transactions),
      );
    });
  }

  Future<void> _onWalletTransactionsUpdated(
    WalletTransactionsUpdated event,
    Emitter<WalletState> emit,
  ) async {
    try {
      final balance = await getBalanceUseCase(event.uid);
      emit(WalletLoaded(balance: balance, transactions: event.transactions));
    } catch (e) {
      emit(WalletError('Failed to update transactions'));
    }
  }

  Future<void> _onAddTransaction(
    AddWalletTransaction event,
    Emitter<WalletState> emit,
  ) async {
    try {
      await addTransactionUseCase(event.uid, event.transaction);
    } catch (e) {
      emit(WalletError('Failed to add transaction'));
    }
  }

  Future<void> _onAddMoneyToWallet(
    AddMoneyToWallet event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletLoading());
    try {
      await addMoneyToWalletUseCase(event.uid, event.amount);
      final newBalance = await getBalanceUseCase(event.uid);
      emit(WalletLoaded(balance: newBalance, transactions: []));
    } catch (e) {
      emit(WalletError('Failed to add money to wallet'));
    }
  }

  @override
  Future<void> close() {
    _transactionSub?.cancel();
    return super.close();
  }
}
