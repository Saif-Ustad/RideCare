import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ridecare/presentation/booking/bloc/booking_event.dart';

import '../../../../common/widgets/bottomBar/bottomBar.dart';
import '../../../../core/configs/theme/app_colors.dart';
import '../../../../domain/entities/vehicle_entity.dart';
import '../../../booking/bloc/booking_bloc.dart';
import '../../bloc/vehicle_bloc.dart';
import '../../bloc/vehicle_event.dart';
import '../../bloc/vehicle_state.dart';

class SelectVehicleFromProfilePage extends StatefulWidget {
  const SelectVehicleFromProfilePage({super.key});

  @override
  _SelectVehicleFromProfilePageState createState() =>
      _SelectVehicleFromProfilePageState();
}

class _SelectVehicleFromProfilePageState
    extends State<SelectVehicleFromProfilePage> {
  String? selectedVehicle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: buildLeadingIconButton(() => context.pop()),
        title: const Text(
          "Select Vehicle",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          buildActionIconButton(() async {
            await context.push("/add-vehicle-profile");
          }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: BlocBuilder<VehicleBloc, VehicleState>(
          builder: (context, state) {
            if (state is VehicleLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is VehicleLoaded) {
              final vehicles = state.vehicles;
              if (vehicles.isEmpty) {
                return const Center(child: Text("No vehicles found."));
              }

              return ListView.builder(
                itemCount: vehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = vehicles[index];
                  return _buildVehicleCard(vehicle);
                },
              );
            } else if (state is VehicleError) {
              return Center(child: Text("Error: ${state.message}"));
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  Widget _buildVehicleCard(VehicleEntity vehicle) {
    final vehicleDisplayName = "${vehicle.brand} ${vehicle.model}";
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.directions_car,
              size: 45,
              color: AppColors.primary,
            ),
            const SizedBox(width: 10),
            Container(width: 1, height: 50, color: AppColors.grey),
          ],
        ),
        title: Text(
          vehicleDisplayName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          "${vehicle.type} • ${vehicle.registrationNumber}",
          style: const TextStyle(fontSize: 14, color: AppColors.darkGrey),
        ),
        trailing: Radio<String>(
          value: vehicle.id,
          groupValue: selectedVehicle,
          onChanged: (value) {
            setState(() {
              selectedVehicle = value;
            });
          },
          activeColor: AppColors.primary,
        ),
      ),
    );
  }

  Widget buildLeadingIconButton(VoidCallback onPressed) => Padding(
    padding: const EdgeInsets.only(left: 15),
    child: circleIconButton(Icons.arrow_back, onPressed),
  );

  Widget buildActionIconButton(VoidCallback onPressed) => Padding(
    padding: const EdgeInsets.only(right: 15),
    child: circleIconButton(Icons.add, onPressed),
  );

  Widget circleIconButton(IconData icon, VoidCallback onPressed) => Container(
    height: 40,
    width: 40,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: AppColors.darkGrey, width: 1),
      color: Colors.white,
    ),
    child: IconButton(
      icon: Icon(icon, color: Colors.black, size: 20),
      onPressed: onPressed,
      constraints: const BoxConstraints(),
      padding: EdgeInsets.zero,
    ),
  );
}
