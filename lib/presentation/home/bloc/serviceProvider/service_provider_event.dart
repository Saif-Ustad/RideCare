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
  final double lat;
  final double lng;

  const FetchNearbyServiceProviders(this.lat, this.lng);

  @override
  List<Object?> get props => [lat, lng];
}
