import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widgets/bottomBar/bottomBar.dart';
import '../../../core/configs/theme/app_colors.dart';

class AddVehiclePage extends StatefulWidget {
  const AddVehiclePage({super.key});

  @override
  _AddVehiclePageState createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  String? selectedBrand;
  String? selectedCar;
  final TextEditingController numberPlateController = TextEditingController();

  final List<String> brands = ["Toyota", "Honda", "Ford"];
  final Map<String, List<String>> cars = {
    "Toyota": ["Fortuner", "Innova", "Corolla"],
    "Honda": ["Civic", "Accord", "City"],
    "Ford": ["Mustang", "Fiesta", "Focus"],
  };

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            _buildTextField("Car Number Plate", numberPlateController),

          ],
        ),
      ),
      bottomNavigationBar:  CustomBottomBar(
        text: "Continue",
        onPressed: () {
          context.push("/select-vehicle");
        },
      ),
    );
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
            // Reduced dropdown height
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

  Widget _buildAddVehicleButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Vehicle Added Successfully!")),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: const Text(
          "Add Vehicle",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
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
        icon: Icon(Icons.arrow_back, color: Colors.black, size: 20),
        onPressed: onPressed,
        constraints: const BoxConstraints(),
        padding: EdgeInsets.zero,
      ),
    ),
  );
}
