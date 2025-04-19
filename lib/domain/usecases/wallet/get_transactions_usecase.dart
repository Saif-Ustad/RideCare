import '../../entities/wallet_transaction_entity.dart';
import '../../repositories/wallet_repository.dart';

class GetWalletTransactionsUseCase {
  final WalletRepository repository;

  GetWalletTransactionsUseCase({required this.repository});

  Stream<List<WalletTransactionEntity>> call(String uid) {
    return repository.getTransactions(uid);
  }
}
