import '../../repositories/wallet_repository.dart';

class GetWalletBalanceUseCase {
  final WalletRepository repository;

  GetWalletBalanceUseCase({required this.repository});

  Future<double> call(String uid) {
    return repository.getWalletBalance(uid);
  }
}
