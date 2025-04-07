import 'package:equatable/equatable.dart';

import '../../../../domain/entities/special_offer_entity.dart';

abstract class SpecialOfferState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SpecialOfferInitial extends SpecialOfferState {}

class SpecialOfferLoading extends SpecialOfferState {}

class SpecialOfferLoaded extends SpecialOfferState {
  final List<SpecialOfferEntity> offers;

  SpecialOfferLoaded(this.offers);

  @override
  List<Object?> get props => [offers];
}

class SpecialOfferError extends SpecialOfferState {
  final String message;

  SpecialOfferError(this.message);

  @override
  List<Object?> get props => [message];
}
