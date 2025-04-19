import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ridecare/domain/entities/wallet_transaction_entity.dart';

class WalletTransactionModel extends WalletTransactionEntity {
  WalletTransactionModel({
    super.id,
    required super.title,
    required super.amount,
    required super.timestamp,
    required super.balanceAfter,
    required super.isCredit,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> map, String id) {
    return WalletTransactionModel(
      id: id,
      title: map['title'],
      amount: (map['amount'] as num).toDouble(),
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      balanceAfter: (map['balanceAfter'] as num).toDouble(),
      isCredit: map['isCredit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'amount': amount,
      'timestamp': timestamp,
      'balanceAfter': balanceAfter,
      'isCredit': isCredit,
    };
  }

  factory WalletTransactionModel.fromEntity(WalletTransactionEntity entity) {
    return WalletTransactionModel(
      id: entity.id,
      title: entity.title,
      amount: entity.amount,
      timestamp: entity.timestamp,
      balanceAfter: entity.balanceAfter,
      isCredit: entity.isCredit,
    );
  }
}
