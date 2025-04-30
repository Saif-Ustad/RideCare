import 'package:equatable/equatable.dart';
import 'package:ridecare/domain/entities/service_provider_entity.dart';

abstract class ServiceProviderState extends Equatable {
  const ServiceProviderState();

  @override
  List<Object?> get props => [];
}

class ServiceProviderInitial extends ServiceProviderState {}

class ServiceProviderLoading extends ServiceProviderState {}

class ServiceProviderLoaded extends ServiceProviderState {
  final List<ServiceProviderEntity> serviceProviders;

  const ServiceProviderLoaded(this.serviceProviders);

  @override
  List<Object?> get props => [serviceProviders];
}

class NearbyServiceProviderLoaded extends ServiceProviderState {
  final List<ServiceProviderEntity> serviceProviders;

  const NearbyServiceProviderLoaded(this.serviceProviders);

  @override
  List<Object?> get props => [serviceProviders];
}

class ServiceProviderError extends ServiceProviderState {
  final String message;

  const ServiceProviderError(this.message);

  @override
  List<Object?> get props => [message];
}
