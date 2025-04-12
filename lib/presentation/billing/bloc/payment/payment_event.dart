import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartPayment extends PaymentEvent {
  final double amount;
  final String name;
  final String email;
  StartPayment({required this.amount, required this.name, required this.email});

  @override
  List<Object?> get props => [amount];
}
