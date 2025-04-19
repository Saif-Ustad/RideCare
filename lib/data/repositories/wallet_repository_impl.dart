import 'package:ridecare/data/datasources/wallet_remote_datasource.dart';
import 'package:ridecare/domain/entities/wallet_transaction_entity.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../models/wallet_transaction_model.dart';

class WalletRepositoryImpl implements WalletRepository {
  WalletRemoteDataSource remoteDataSource;

  WalletRepositoryImpl({required this.remoteDataSource});

  @override
  Future<double> getWalletBalance(String uid) {
    return remoteDataSource.getWalletBalance(uid);
  }

  @override
  Stream<List<WalletTransactionEntity>> getTransactions(String uid) {
    return remoteDataSource.getTransactions(uid);
  }

  @override
  Future<void> addTransaction(String uid, WalletTransactionEntity transaction) {
    return remoteDataSource.addTransaction(
      uid,
      WalletTransactionModel.fromEntity(transaction),
    );
  }

  @override
  Future<void> addMoneyToWallet(String uid, double amount) {
      return remoteDataSource.addMoneyToWallet(uid, amount);
  }
}
