import 'package:equatable/equatable.dart';

abstract class ServiceProviderEvent extends Equatable {
  const ServiceProviderEvent();

  @override
  List<Object?> get props => [];
}

class FetchAllServiceProviders extends ServiceProviderEvent {
  const FetchAllServiceProviders();
}

class FetchNearbyServiceProviders extends ServiceProviderEvent {
  final double latitude;
  final double longitude;

  const FetchNearbyServiceProviders(this.latitude, this.longitude);

  @override
  List<Object?> get props => [latitude, longitude];
}
