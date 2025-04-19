import '../../repositories/wallet_repository.dart';

class AddMoneyToWalletUseCase {
  final WalletRepository repository;

  AddMoneyToWalletUseCase({required this.repository});

  Future<void> call(String uid, double amount) async {
    await repository.addMoneyToWallet(uid, amount);
  }
}
