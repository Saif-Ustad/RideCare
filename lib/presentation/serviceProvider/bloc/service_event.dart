import 'package:equatable/equatable.dart';

abstract class ServiceEvent extends Equatable {
  const ServiceEvent();

  @override
  List<Object?> get props => [];
}

class FetchAllServiceForProvider extends ServiceEvent {
  final String providerId;

  const FetchAllServiceForProvider(this.providerId);

  @override
  List<Object?> get props => [providerId];
}
