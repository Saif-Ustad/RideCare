import 'package:bloc/bloc.dart';
import 'package:ridecare/domain/usecases/serviceProvider/get_all_service_providers.dart';
import '../../../../domain/entities/service_provider_entity.dart';
import 'service_provider_event.dart';
import 'service_provider_state.dart';

class ServiceProviderBloc extends Bloc<ServiceProviderEvent, ServiceProviderState> {
  final GetAllServiceProviders getAllServiceProviders;

  ServiceProviderBloc({required this.getAllServiceProviders}) : super(ServiceProviderInitial()) {
    on<FetchAllServiceProviders>(_onFetchAll);
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
        onError: (_, __) => const ServiceProviderError('Failed to fetch providers'),
      );
    } catch (_) {
      emit(const ServiceProviderError('Something went wrong'));
    }
  }
}
