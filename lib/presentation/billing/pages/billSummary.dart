import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ridecare/core/configs/assets/app_images.dart';
import '../../../common/widgets/bottomBar/bottomBar.dart';
import '../../../core/configs/theme/app_colors.dart';

class BillSummaryPage extends StatelessWidget {
  const BillSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample Data Defined Inside the Class
    final ServiceCenter serviceCenter = ServiceCenter(
      name: "Bajaj Service Center",
      serviceType: "Car Repair",
      imageUrl: AppImages.serviceProvider1,
      rating: 4.6,
      distance: 5.2,
      time: 15,
    );

    final BookingDetails bookingDetails = BookingDetails(
      dateTime: "Mar 04, 2025",
      carDetails: "SUV | MH 09 ER 65XX",
      serviceType: "Pick-Up",
    );

    final List<BillItem> billItems = [
      BillItem(name: "Wax", price: 250),
      BillItem(name: "Scratch Removal", price: 750),
      BillItem(name: "Tax & Fees", price: 35),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _buildLeadingIconButton(() => context.pop()),
        title: const Text(
          "Review Summary",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildServiceCenterDetails(serviceCenter),
                      const Divider(thickness: 1, height: 20),
                      _buildSummaryDetails(bookingDetails, billItems),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildPromoCodeSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        text: "Continue",
        onPressed: () {
          context.push("/payment-gateway");
        },
      ),
    );
  }

  Widget _buildServiceCenterDetails(ServiceCenter serviceCenter) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            serviceCenter.imageUrl,
            width: 150,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightGray,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    serviceCenter.serviceType,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.star, color: Colors.amber, size: 16),
                Text(
                  "${serviceCenter.rating}",
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              serviceCenter.name,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 12,
                  color: AppColors.primary.withOpacity(0.8),
                ),
                Text(
                  "${serviceCenter.distance} km ",
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.darkGrey,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  Icons.access_time,
                  size: 12,
                  color: AppColors.primary.withOpacity(0.8),
                ),
                Text(
                  " ${serviceCenter.time} mins",
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.darkGrey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryDetails(
    BookingDetails bookingDetails,
    List<BillItem> billItems,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSummaryRow("Booking Date", bookingDetails.dateTime),
        _buildSummaryRow("Car", bookingDetails.carDetails),
        _buildSummaryRow("Service Type", bookingDetails.serviceType),
        const Divider(thickness: 1),
        ...billItems.map(
          (item) => _buildSummaryRow(item.name, "Rs. ${item.price}"),
        ),
        const Divider(thickness: 1, color: Colors.grey),
        _buildSummaryRow(
          "Total",
          "Rs. ${billItems.fold(0.0, (sum, item) => sum + item.price)}",
          isBold: true,
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
              color: AppColors.darkGrey,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCodeSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 50,
          width: 250,
          decoration: BoxDecoration(
            color: AppColors.lightGray,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              hintText: "Promo Code",
              border: InputBorder.none,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => _applyPromo("PROMO"),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          ),
          child: const Text("Apply", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  void _applyPromo(String code) {
    // Implement promo code logic here
    print("Promo code applied: $code");
  }

  Widget _buildLeadingIconButton(VoidCallback onPressed) => Padding(
    padding: const EdgeInsets.only(left: 15),
    child: Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.darkGrey, width: 1),
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
        onPressed: onPressed,
      ),
    ),
  );
}

// Data Models
class ServiceCenter {
  final String name, serviceType, imageUrl;
  final double rating, distance, time;

  ServiceCenter({
    required this.name,
    required this.serviceType,
    required this.imageUrl,
    required this.rating,
    required this.distance,
    required this.time,
  });
}

class BookingDetails {
  final String dateTime, carDetails, serviceType;

  BookingDetails({
    required this.dateTime,
    required this.carDetails,
    required this.serviceType,
  });
}

class BillItem {
  final String name;
  final double price;

  BillItem({required this.name, required this.price});
}
