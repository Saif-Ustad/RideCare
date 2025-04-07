import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridecare/domain/usecases/service/get_services_for_provider.dart';
import 'package:ridecare/presentation/serviceProvider/bloc/service_event.dart';
import 'package:ridecare/presentation/serviceProvider/bloc/service_state.dart';

import '../../../domain/entities/service_entity.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final GetAllServiceForProvider getAllServiceForProvider;

  ServiceBloc({required this.getAllServiceForProvider})
    : super(ServiceInitial()) {
    on<FetchAllServiceForProvider>(_onFetchAll);
  }

  Future<void> _onFetchAll(
    FetchAllServiceForProvider event,
    Emitter<ServiceState> emit,
  ) async {
    emit(ServiceLoading());
    try {
      await emit.forEach<List<ServiceEntity>>(
        getAllServiceForProvider(event.providerId),
        onData: (services) => ServiceLoaded(services),
        onError: (_, __) => const ServiceError('Failed to fetch services'),
      );
    } catch (_) {
      emit(const ServiceError('Something went wrong'));
    }
  }
}
