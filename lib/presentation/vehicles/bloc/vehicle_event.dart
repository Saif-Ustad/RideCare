import 'package:equatable/equatable.dart';

import '../../../domain/entities/vehicle_entity.dart';

abstract class VehicleEvent extends Equatable {
  const VehicleEvent();

  @override
  List<Object?> get props => [];
}

class LoadVehicles extends VehicleEvent {
  final String userId;

  const LoadVehicles(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AddVehicle extends VehicleEvent {
  final VehicleEntity vehicle;

  const AddVehicle(this.vehicle);

  @override
  List<Object?> get props => [vehicle];
}

class UpdateVehicle extends VehicleEvent {
  final VehicleEntity vehicle;

  const UpdateVehicle(this.vehicle);

  @override
  List<Object?> get props => [vehicle];
}

class DeleteVehicle extends VehicleEvent {
  final String vehicleId;

  const DeleteVehicle(this.vehicleId);

  @override
  List<Object?> get props => [vehicleId];
}
