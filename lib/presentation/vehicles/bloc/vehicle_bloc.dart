import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:ridecare/domain/entities/notification_entity.dart';
import '../../../domain/entities/vehicle_entity.dart';
import '../../../domain/usecases/vehicle/addVehicleUseCase.dart';
import '../../../domain/usecases/vehicle/deleteVehicleUseCase.dart';
import '../../../domain/usecases/vehicle/getVehiclesUseCase.dart';
import '../../../domain/usecases/vehicle/updateVehicleUseCase.dart';
import '../../home/bloc/notification/notification_bloc.dart';
import '../../home/bloc/notification/notification_event.dart';
import 'vehicle_event.dart';
import 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final GetVehiclesUseCase getVehicles;
  final AddVehicleUseCase addVehicle;
  final UpdateVehicleUseCase updateVehicle;
  final DeleteVehicleUseCase deleteVehicle;

  final NotificationBloc notificationBloc = GetIt.I<NotificationBloc>();

  VehicleBloc({
    required this.getVehicles,
    required this.addVehicle,
    required this.updateVehicle,
    required this.deleteVehicle,
  }) : super(VehicleInitial()) {
    on<LoadVehicles>(_onLoadVehicles);
    on<AddVehicle>(_onAddVehicle);
    on<UpdateVehicle>(_onUpdateVehicle);
    on<DeleteVehicle>(_onDeleteVehicle);
  }

  Future<void> _onLoadVehicles(
    LoadVehicles event,
    Emitter<VehicleState> emit,
  ) async {
    emit(VehicleLoading());
    await emit.forEach<List<VehicleEntity>>(
      getVehicles(event.userId),
      onData: (vehicles) => VehicleLoaded(vehicles),
      onError: (error, _) => VehicleError(error.toString()),
    );
  }

  Future<void> _onAddVehicle(
    AddVehicle event,
    Emitter<VehicleState> emit,
  ) async {
    try {
      await addVehicle(event.vehicle);
      final NotificationEntity notification = NotificationEntity(
        title: "Vehicle Added",
        body:
            'Your vehicle (${event.vehicle.brand} - ${event.vehicle.registrationNumber}) has been added successfully.',
        type: "Vehicle Add",
      );

      notificationBloc.add(
        AddNotificationEvent(
          userId: event.vehicle.userId,
          notification: notification,
        ),
      );
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }

  Future<void> _onUpdateVehicle(
    UpdateVehicle event,
    Emitter<VehicleState> emit,
  ) async {
    try {
      await updateVehicle(event.vehicle);
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }

  Future<void> _onDeleteVehicle(
    DeleteVehicle event,
    Emitter<VehicleState> emit,
  ) async {
    try {
      await deleteVehicle(event.vehicleId);
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }
}
