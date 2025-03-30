import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../common/widgets/bottomBar/bottomBar.dart';
import '../../../core/configs/theme/app_colors.dart';

class SelectVehiclePage extends StatefulWidget {
  const SelectVehiclePage({super.key});

  @override
  _SelectVehiclePageState createState() => _SelectVehiclePageState();
}

class _SelectVehiclePageState extends State<SelectVehiclePage> {
  String? selectedVehicle;

  final List<Map<String, String>> vehicles = [
    {"name": "Toyota Fortuner", "type": "SUV", "number": "MH 09 65XX"},
    {"name": "Honda Civic", "type": "Sedan", "number": "MH 10 45YY"},
    {"name": "Ford Mustang", "type": "Sports", "number": "MH 12 89ZZ"},
  ];

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
          buildActionIconButton(() {
            context.push("/add-vehicle");
          }),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Expanded(
          child: ListView.builder(
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              return _buildVehicleCard(vehicle);
            },
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        text: "Continue",
        onPressed: () {
          context.push("/select-location");
        },
      ),
    );
  }

  Widget _buildVehicleCard(Map<String, String> vehicle) {
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
          vehicle["name"]!,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          "${vehicle["type"]} • ${vehicle["number"]}",
          style: const TextStyle(fontSize: 14, color: AppColors.darkGrey),
        ),
        trailing: Radio<String>(
          value: vehicle["name"]!,
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
