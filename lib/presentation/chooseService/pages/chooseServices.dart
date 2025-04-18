import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../booking/bloc/booking_bloc.dart';
import '../../booking/bloc/booking_event.dart';
import '../../serviceProvider/bloc/services/service_bloc.dart';
import '../../serviceProvider/bloc/services/service_state.dart';
import '../widgets/serviceOption.dart';
import '../../../../domain/entities/service_entity.dart';

class ChooseServicesPage extends StatefulWidget {
  final String serviceProviderId;

  const ChooseServicesPage({super.key, required this.serviceProviderId});

  @override
  _ChooseServicesPageState createState() => _ChooseServicesPageState();
}

class _ChooseServicesPageState extends State<ChooseServicesPage> {
  String selectedCategory = '';
  final Map<String, List<ServiceOption>> categoryServices = {};

  double get subtotal {
    return categoryServices.values
        .expand((services) => services)
        .where((service) => service.isSelected)
        .fold(0, (sum, service) => sum + service.price);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: BlocBuilder<ServiceBloc, ServiceState>(
        builder: (context, state) {
          if (state is ServiceLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ServiceLoaded) {
            // Only build category services if it's empty (to persist state)
            if (categoryServices.isEmpty) {
              _buildCategoryServices(state.services);
            }

            return Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  _buildCategoryTabs(),
                  Divider(color: AppColors.lightGray, thickness: 1, height: 25),
                  Expanded(
                    child: ListView(
                      children: [
                        const Text(
                          "Add Options",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 15),
                        ..._getSelectedServices().map(
                          (service) => _serviceTile(service),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ServiceError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox();
          }
        },
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
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
    );
  }

  void _buildCategoryServices(List<ServiceEntity> services) {
    for (final service in services) {
      final category = service.categoryName;
      final existingServices = categoryServices[category] ?? [];

      // Check if service already exists by name
      final alreadyExists = existingServices.any((s) => s.name == service.name);
      if (!alreadyExists) {
        existingServices.add(
          ServiceOption(
            serviceId: service.id,
            name: service.name,
            price: service.price,
            isSelected: false,
            description: service.description,
          ),
        );
      }

      categoryServices[category] = existingServices;
    }

    if (selectedCategory.isEmpty && categoryServices.isNotEmpty) {
      selectedCategory = categoryServices.keys.first;
    }
  }

  List<ServiceOption> _getSelectedServices() {
    return categoryServices[selectedCategory] ?? [];
  }

  Widget _buildCategoryTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            categoryServices.keys
                .map((category) => _categoryTab(category))
                .toList(),
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
                  service.isSelected = value ?? false;
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
                  Text(
                    service.description,
                    style: const TextStyle(
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

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        borderRadius: const BorderRadius.only(
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
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              final selectedServices =
                  categoryServices.values
                      .expand((list) => list)
                      .where((s) => s.isSelected)
                      .map((s) => s.serviceId)
                      .toList();

              if (selectedServices.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please select at least one service")),
                );
                return;
              }

              // Dispatch to BookingBloc
              context.read<BookingBloc>().add(
                SelectService(
                  serviceIds: selectedServices,
                  providerId: widget.serviceProviderId,
                ),
              );

              // Navigate to next page
              context.push(
                "/appointment-booking?serviceProviderId=${widget.serviceProviderId}",
              );
            },

            child: const Text(
              "Next",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
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
