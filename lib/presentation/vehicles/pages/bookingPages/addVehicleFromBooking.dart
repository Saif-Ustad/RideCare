import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../../common/widgets/bottomBar/bottomBar.dart';
import '../../../../core/configs/theme/app_colors.dart';
import '../../../../domain/entities/vehicle_entity.dart';
import '../../../home/bloc/user/user_bloc.dart';
import '../../../home/bloc/user/user_state.dart';
import '../../bloc/vehicle_bloc.dart';
import '../../bloc/vehicle_event.dart';
import '../../bloc/vehicle_state.dart';

class AddVehicleFromBookingPage extends StatefulWidget {
  const AddVehicleFromBookingPage({super.key});

  @override
  _AddVehicleFromBookingPageState createState() =>
      _AddVehicleFromBookingPageState();
}

class _AddVehicleFromBookingPageState extends State<AddVehicleFromBookingPage> {
  final TextEditingController numberPlateController = TextEditingController();

  String? selectedBrand;
  String? selectedCar;
  String? selectedType;
  String? selectedFuel;

  String? userId;

  final List<String> brands = ["Toyota", "Honda", "Ford"];
  final Map<String, List<String>> cars = {
    "Toyota": ["Fortuner", "Innova", "Corolla"],
    "Honda": ["Civic", "Accord", "City"],
    "Ford": ["Mustang", "Fiesta", "Focus"],
  };
  final List<String> types = ["SUV", "Sedan", "Hatchback", "Truck"];
  final List<String> fuelTypes = ["Petrol", "Diesel", "Electric", "Hybrid"];

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<UserBloc>().state;

    if (userState is! UserLoaded) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    userId = userState.user.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _buildLeadingIconButton(() => context.pop()),
        title: const Text(
          "Add Vehicle",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<VehicleBloc, VehicleState>(
        listener: (context, state) {
          if (state is VehicleLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Vehicle added successfully")),
            );
            context.push("/select-vehicle-booking");
          } else if (state is VehicleError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDropdownSearch("Select Brand", brands, selectedBrand, (
                    value,
                  ) {
                    setState(() {
                      selectedBrand = value;
                      selectedCar = null;
                    });
                  }),
                  const SizedBox(height: 16),
                  _buildDropdownSearch(
                    "Select Car",
                    cars[selectedBrand] ?? [],
                    selectedCar,
                    (value) {
                      setState(() {
                        selectedCar = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownSearch("Vehicle Type", types, selectedType, (
                    value,
                  ) {
                    setState(() {
                      selectedType = value;
                    });
                  }),
                  const SizedBox(height: 16),
                  _buildDropdownSearch("Fuel Type", fuelTypes, selectedFuel, (
                    value,
                  ) {
                    setState(() {
                      selectedFuel = value;
                    });
                  }),
                  const SizedBox(height: 16),
                  _buildTextField("Car Number Plate", numberPlateController),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomBar(
        text: "Save Vehicle",
        onPressed: _onSaveVehicle,
      ),
    );
  }

  void _onSaveVehicle() {
    if (selectedBrand != null &&
        selectedCar != null &&
        selectedType != null &&
        selectedFuel != null &&
        userId != null &&
        numberPlateController.text.isNotEmpty) {
      final id = const Uuid().v4();

      final vehicle = VehicleEntity(
        id: id,
        brand: selectedBrand!,
        model: selectedCar!,
        type: selectedType!,
        fuelType: selectedFuel!,
        registrationNumber: numberPlateController.text,
        userId: userId!,
      );

      context.read<VehicleBloc>().add(AddVehicle(vehicle));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
    }
  }

  Widget _buildDropdownSearch(
    String label,
    List<String> items,
    String? selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 6),
        DropdownSearch<String>(
          items: items,
          selectedItem: selectedValue,
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              fillColor: Colors.white,
              filled: true,
            ),
          ),
          onChanged: onChanged,
          popupProps: PopupProps.menu(
            showSearchBox: true,
            constraints: const BoxConstraints(maxHeight: 250),
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            menuProps: MenuProps(backgroundColor: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Ex. MH 09 65XX",
            hintStyle: TextStyle(
              color: AppColors.darkGrey,
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeadingIconButton(VoidCallback onPressed) => Padding(
    padding: const EdgeInsets.only(left: 15),
    child: Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.darkGrey, width: 1),
        color: Colors.white,
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
        onPressed: onPressed,
        constraints: const BoxConstraints(),
        padding: EdgeInsets.zero,
      ),
    ),
  );
}
