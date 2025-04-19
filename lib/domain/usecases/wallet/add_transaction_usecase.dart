import '../../entities/wallet_transaction_entity.dart';
import '../../repositories/wallet_repository.dart';

class AddWalletTransactionUseCase {
  final WalletRepository repository;

  AddWalletTransactionUseCase({required this.repository});

  Future<void> call(String uid, WalletTransactionEntity transaction) {
    return repository.addTransaction(uid, transaction);
  }
}
