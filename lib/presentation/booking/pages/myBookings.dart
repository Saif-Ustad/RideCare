import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';

class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
          "My Bookings",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [buildActionIconButton(() {})],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            indicatorColor: Colors.purple,
            tabs: const [
              Tab(text: "Active"),
              Tab(text: "Completed"),
              Tab(text: "Cancelled"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBookingsList(activeBookings),
                _buildBookingsList(completedBookings),
                _buildBookingsList(cancelledBookings),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList(List<Booking> bookings) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return _buildBookingCard(booking);
      },
    );
  }

  Widget _buildBookingCard(Booking booking) {
    bool isCancelled = booking.status == "Cancelled";

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Tag
            Container(
              decoration: BoxDecoration(
                color: booking.statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                booking.status,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: booking.statusColor,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Image and Service Info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    booking.imageUrl,
                    width: 120,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.lightGray,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: const Text(
                          "Car Service",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        booking.serviceCenter,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),

                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 5),
                          Text("${booking.distance} km", style: _infoTextStyle),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.timer,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 5),
                          Text("${booking.time} mins", style: _infoTextStyle),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Order Details
            Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: "Order ID\n",
                      style: _infoTextStyle,
                      children: [
                        TextSpan(
                          text: "#${booking.orderId}",
                          style: _infoTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: "Order Date\n",
                      style: _infoTextStyle,
                      children: [
                        TextSpan(
                          text: booking.orderDate,
                          style: _infoTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: "Total Payment\n",
                      style: _infoTextStyle,
                      children: [
                        TextSpan(
                          text: "Rs. ${booking.payment}",
                          style: _infoTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Action Buttons
            Row(
              children: [
                if (!isCancelled) ...[
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.lightGray,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: booking.btn1OnPressed,
                      child: Text(
                        booking.btn1,
                        style: TextStyle(fontSize: 14, color: AppColors.black),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: booking.btn2OnPressed,
                      child: Text(
                        booking.btn2,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
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

TextStyle get _infoTextStyle =>
    const TextStyle(fontSize: 12, color: AppColors.darkGrey);

class Booking {
  final String serviceCenter, orderId, orderDate, imageUrl, status, btn1, btn2;
  final double distance, time, payment;
  final Color statusColor;
  final VoidCallback btn1OnPressed, btn2OnPressed;

  Booking({
    required this.serviceCenter,
    required this.orderId,
    required this.orderDate,
    required this.imageUrl,
    required this.status,
    required this.statusColor,
    required this.distance,
    required this.time,
    required this.payment,
    required this.btn1,
    required this.btn2,
    required this.btn1OnPressed,
    required this.btn2OnPressed,
  });
}

List<Booking> activeBookings = [
  Booking(
    serviceCenter: "Bajaj Service Center",
    orderId: "CRR0265A53",
    orderDate: "4 Mar",
    imageUrl: AppImages.popularServiceProvider1,
    status: "Order Pending",
    statusColor: AppColors.orange,
    distance: 0.5,
    time: 2,
    payment: 1035,
    btn1: "Cancle",
    btn2: "Track Order",
    btn1OnPressed: () => {},
    btn2OnPressed: () => {},
  ),
  Booking(
    serviceCenter: "Honda Service Center",
    orderId: "CRD3275A56",
    orderDate: "2 Mar",
    imageUrl: AppImages.popularServiceProvider2,
    status: "Order Confirmed",
    statusColor: Colors.green,
    distance: 1.5,
    time: 8,
    payment: 2835,
    btn1: "Cancle",
    btn2: "Track Order",
    btn1OnPressed: () => {},
    btn2OnPressed: () => {},
  ),
];

List<Booking> completedBookings = [
  Booking(
    serviceCenter: "Toyota Service Center",
    orderId: "CRD3275A56",
    orderDate: "2 Mar",
    imageUrl: AppImages.popularServiceProvider2,
    status: "Order Confirmed",
    statusColor: Colors.green,
    distance: 1.5,
    time: 8,
    payment: 2835,
    btn1: "Leave Review",
    btn2: "E-Reciept",
    btn1OnPressed: () => {},
    btn2OnPressed: () => {},
  ),
];
List<Booking> cancelledBookings = [
  Booking(
    serviceCenter: "Mazda Service Center",
    orderId: "CRD3275A56",
    orderDate: "2 Mar",
    imageUrl: AppImages.popularServiceProvider2,
    status: "Cancelled",
    statusColor: AppColors.orange,
    distance: 1.5,
    time: 8,
    payment: 2835,
    btn1: "Leave Review",
    btn2: "E-Reciept",
    btn1OnPressed: () => {},
    btn2OnPressed: () => {},
  ),
  Booking(
    serviceCenter: "Ferrari Service Center",
    orderId: "CRD3275A56",
    orderDate: "2 Mar",
    imageUrl: AppImages.popularServiceProvider2,
    status: "Cancelled",
    statusColor: AppColors.orange,
    distance: 1.5,
    time: 8,
    payment: 2835,
    btn1: "Leave Review",
    btn2: "E-Reciept",
    btn1OnPressed: () => {},
    btn2OnPressed: () => {},
  ),
];
