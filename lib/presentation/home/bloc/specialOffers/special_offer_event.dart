import 'package:equatable/equatable.dart';

abstract class SpecialOfferEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchSpecialOffers extends SpecialOfferEvent {}
