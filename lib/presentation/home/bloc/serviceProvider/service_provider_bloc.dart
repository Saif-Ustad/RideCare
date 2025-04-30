import 'package:bloc/bloc.dart';
import 'package:ridecare/domain/usecases/serviceProvider/get_all_service_providers.dart';
import 'package:ridecare/domain/usecases/serviceProvider/get_nearby_service_providers.dart';
import '../../../../domain/entities/service_provider_entity.dart';
import 'service_provider_event.dart';
import 'service_provider_state.dart';

class ServiceProviderBloc
    extends Bloc<ServiceProviderEvent, ServiceProviderState> {
  final GetAllServiceProviders getAllServiceProviders;
  final GetNearbyServiceProviders getNearbyServiceProviders;

  ServiceProviderBloc({
    required this.getAllServiceProviders,
    required this.getNearbyServiceProviders,
  }) : super(ServiceProviderInitial()) {
    on<FetchAllServiceProviders>(_onFetchAll);
    on<FetchNearbyServiceProviders>(_onFetchNearby);
  }

  Future<void> _onFetchAll(
    FetchAllServiceProviders event,
    Emitter<ServiceProviderState> emit,
  ) async {
    emit(ServiceProviderLoading());
    try {
      await emit.forEach<List<ServiceProviderEntity>>(
        getAllServiceProviders(),
        onData: (providers) => ServiceProviderLoaded(providers),
        onError:
            (_, __) => const ServiceProviderError('Failed to fetch providers'),
      );
    } catch (_) {
      emit(const ServiceProviderError('Something went wrong'));
    }
  }

  Future<void> _onFetchNearby(
    FetchNearbyServiceProviders event,
    Emitter<ServiceProviderState> emit,
  ) async {
    emit(ServiceProviderLoading());
    try {
      await emit.forEach<List<ServiceProviderEntity>>(
        getNearbyServiceProviders(event.latitude, event.longitude),
        onData: (providers) {
          print('Received providers: ${providers[0].name}');
          // return NearbyServiceProviderLoaded(providers);
          return ServiceProviderLoaded(providers);
        },
        onError:
            (_, __) =>
                const ServiceProviderError('Failed to fetch nearby providers'),
      );
    } catch (_) {
      emit(const ServiceProviderError('Something went wrong'));
    }
  }
}
