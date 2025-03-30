import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/configs/theme/app_colors.dart';

class ChooseServicesPage extends StatefulWidget {
  const ChooseServicesPage({super.key});

  @override
  _ChooseServicesPageState createState() => _ChooseServicesPageState();
}

class _ChooseServicesPageState extends State<ChooseServicesPage> {
  String selectedCategory = "Car Wash";

  final Map<String, List<ServiceOption>> categoryServices = {
    "Car Wash": [
      ServiceOption(name: "Wax", price: 250, isSelected: false),
      ServiceOption(name: "Scratch Removal", price: 750, isSelected: false),
      ServiceOption(name: "Water-dot Removal", price: 620, isSelected: false),
    ],
    "Repairs": [
      ServiceOption(name: "Engine Fix", price: 1500, isSelected: false),
      ServiceOption(name: "Brake Repair", price: 1200, isSelected: false),
    ],
    "Maintenance": [
      ServiceOption(name: "Oil Change", price: 800, isSelected: false),
      ServiceOption(name: "Tire Rotation", price: 500, isSelected: false),
    ],
    "Diagnostics": [
      ServiceOption(name: "Full Car Scan", price: 2000, isSelected: false),
    ],
  };

  List<ServiceOption> get services => categoryServices[selectedCategory] ?? [];

  double get subtotal {
    return categoryServices.values
        .expand((services) => services)
        .where((service) => service.isSelected)
        .fold(0, (sum, service) => sum + service.price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: buildLeadingIconButton(() => context.pop()),
        title: const Text(
          "Choose Services",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [buildActionIconButton(() {})],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    categoryServices.keys
                        .map((category) => _categoryTab(category))
                        .toList(),
              ),
            ),

            Divider(color: AppColors.lightGray, thickness: 1, height: 25),

            Expanded(
              child: ListView(
                children: [
                  const Text(
                    "Add Options",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 15),
                  ...services.map((service) => _serviceTile(service)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Subtotal",
                  style: TextStyle(color: AppColors.darkGrey),
                ),
                Text(
                  "Rs. ${subtotal.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () { context.push("/appointment-booking");},
              child: const Text(
                "Next",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryTab(String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor:
              selectedCategory == title
                  ? AppColors.primary
                  : AppColors.lightGray,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () {
          setState(() {
            selectedCategory = title;
          });
        },
        child: Text(
          title,
          style: TextStyle(
            color:
                selectedCategory == title ? Colors.white : AppColors.darkGrey,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _serviceTile(ServiceOption service) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: service.isSelected,
              activeColor: AppColors.primary,
              onChanged: (bool? value) {
                setState(() {
                  service.isSelected = value!;
                });
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Post description facilisis dolor sapien, vef sodoles augue mollis ut ",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.darkGrey,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "Rs. ${service.price}",
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ],
        ),
        Divider(color: AppColors.lightGray, thickness: 1, height: 20),
      ],
    );
  }

  Widget buildLeadingIconButton(VoidCallback onPressed) => Padding(
    padding: const EdgeInsets.only(left: 15),
    child: circleIconButton(Icons.arrow_back, onPressed),
  );

  Widget buildActionIconButton(VoidCallback onPressed) => Padding(
    padding: const EdgeInsets.only(right: 15),
    child: circleIconButton(Icons.search, onPressed),
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

class ServiceOption {
  final String name;
  final double price;
  bool isSelected;

  ServiceOption({
    required this.name,
    required this.price,
    required this.isSelected,
  });
}
