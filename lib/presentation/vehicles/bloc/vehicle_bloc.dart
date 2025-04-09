import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/vehicle_entity.dart';
import '../../../domain/usecases/vehicle/addVehicleUseCase.dart';
import '../../../domain/usecases/vehicle/deleteVehicleUseCase.dart';
import '../../../domain/usecases/vehicle/getVehiclesUseCase.dart';
import '../../../domain/usecases/vehicle/updateVehicleUseCase.dart';
import 'vehicle_event.dart';
import 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final GetVehiclesUseCase getVehicles;
  final AddVehicleUseCase addVehicle;
  final UpdateVehicleUseCase updateVehicle;
  final DeleteVehicleUseCase deleteVehicle;

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
