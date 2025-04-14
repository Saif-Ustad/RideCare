import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ridecare/domain/entities/booking_entity.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../home/bloc/user/user_bloc.dart';
import '../../home/bloc/user/user_state.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';
import 'package:intl/intl.dart';

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
    final currentUser = (context.read<UserBloc>().state as UserLoaded).user;
    print("user now: ${currentUser.uid}");
    context.read<BookingBloc>().add(GetAllBookings(userId: currentUser.uid));
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
            child: BlocBuilder<BookingBloc, BookingState>(
              builder: (context, state) {
                if (state is BookingLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BookingError) {
                  return Center(child: Text("Error: ${state.message}"));
                } else if (state is BookingsLoaded) {
                  final activeBookings =
                      state.bookings
                          .where(
                            (b) =>
                                b.status == "Order Pending" ||
                                b.status == "Order Confirmed",
                          )
                          .toList();
                  final completedBookings =
                      state.bookings
                          .where((b) => b.status == "Order Completed")
                          .toList();
                  final cancelledBookings =
                      state.bookings
                          .where((b) => b.status == "Order Cancelled")
                          .toList();

                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildBookingsList(activeBookings, "Active"),
                      _buildBookingsList(completedBookings, "Completed"),
                      _buildBookingsList(cancelledBookings, "Cancelled"),
                    ],
                  );
                } else {
                  return const Center(child: Text("No bookings available"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList(List<BookingEntity> bookings, String tabName) {
    if (bookings.isEmpty) {
      return const Center(child: Text("No bookings found."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return _buildBookingCard(booking, tabName);
      },
    );
  }

  Widget _buildBookingCard(BookingEntity booking, String tabName) {
    bool isCancelled = booking.status == "Order Cancelled";
    final Color statusColor = _getStatusColor(
      tabName,
      booking.status ?? "No Status",
    );

    final Map<String, dynamic> buttonsInfo = {
      "btn1": {
        "btnText": tabName == "Active" ? "Cancel" : "Leave Review",
        "btnRoute":
            tabName == "Active"
                ? "/cancel-booking/${booking.bookingId}"
                : "/add-review/${booking.serviceProviderId}",
      },
      "btn2": {
        "btnText": tabName == "Active" ? "Track Order" : "E-Receipt",
        "btnRoute":
            tabName == "Active"
                ? "/track-order/${booking.trackingId}"
                : "/e-receipt/${booking.bookingId}",
      },
    };

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
                color: statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                booking.status ?? "No Status",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: statusColor,
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
                  child: CachedNetworkImage(
                    imageUrl: booking.serviceProvider!.workImageUrl,
                    width: 120,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) => Container(
                          width: 120,
                          height: 80,
                          color: Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                    errorWidget:
                        (context, url, error) => Container(
                          width: 120,
                          height: 80,
                          color: Colors.grey[300],
                          child: const Icon(Icons.error, color: Colors.red),
                        ),
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
                        booking.serviceProvider?.name ?? 'No Name',
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
                          Text("${1.5} km", style: _infoTextStyle),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.timer,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 5),
                          Text("${10} mins", style: _infoTextStyle),
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
                          text: "#TR4365HGJKL",
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
                          text:
                              booking.scheduledAt != null
                                  ? DateFormat(
                                    'd MMMM yy',
                                  ).format(booking.scheduledAt!)
                                  : '',

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
                          text: "Rs. ${booking.totalCharges}",
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
                if (!isCancelled &&
                    buttonsInfo['btn1']['btnRoute'] != null) ...[
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.lightGray,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed:
                          () => context.push(buttonsInfo['btn1']['btnRoute']),
                      child: Text(
                        buttonsInfo['btn1']['btnText'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                if (!isCancelled &&
                    buttonsInfo['btn2']['btnRoute'] != null) ...[
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed:
                          () => context.push(buttonsInfo['btn2']['btnRoute']),
                      child: Text(
                        buttonsInfo['btn2']['btnText'],
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

  Color _getStatusColor(String tabName, String status) {
    if (tabName == "Completed") {
      return Colors.green;
    } else if (tabName == "Cancelled" || status == "Order Pending") {
      return AppColors.orange;
    } else {
      return Colors.green;
    }
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
