import 'package:equatable/equatable.dart';

abstract class PaymentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {}

class PaymentFailed extends PaymentState {
  final String error;
  PaymentFailed(this.error);

  @override
  List<Object?> get props => [error];
}
