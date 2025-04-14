import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:intl/intl.dart';
import 'package:ridecare/core/configs/theme/app_colors.dart';

import '../../booking/bloc/booking_bloc.dart';
import '../../booking/bloc/booking_event.dart';
import '../../booking/bloc/booking_state.dart';
import '../../home/bloc/user/user_bloc.dart';
import '../../home/bloc/user/user_state.dart';

class EReceiptPage extends StatefulWidget {
  final String bookingId;

  const EReceiptPage({super.key, required this.bookingId});

  @override
  State<EReceiptPage> createState() => _EReceiptPageState();
}

class _EReceiptPageState extends State<EReceiptPage> {
  @override
  void initState() {
    super.initState();
    final userState = context.read<UserBloc>().state;
    if (userState is UserLoaded) {
      final user = userState.user;
      context.read<BookingBloc>().add(GetAllBookings(userId: user.uid));
    }
  }

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return "-";
    return DateFormat('MMM dd, yyyy | hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        if (state is BookingLoading) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is BookingsLoaded) {
          final bookings = state.bookings;
          final booking = bookings.firstWhere(
            (b) => b.bookingId == widget.bookingId,
            // orElse: () => BookingEntity(),
          );

          if (booking.bookingId == null) {
            return const Scaffold(
              body: Center(child: Text("Booking not found.")),
            );
          }

          final discountPercentage =
              booking.promoCodeInfo?['discountPercentage'];
          final totalCharges = booking.totalCharges ?? 0.0;

          double originalAmount = totalCharges;
          double discountAmount = 0.0;

          if (discountPercentage != null && discountPercentage > 0) {
            originalAmount = totalCharges / (1 - (discountPercentage / 100));
            discountAmount = originalAmount - totalCharges;
          }

          final receiptData = {
            "transactionId": booking.bookingId ?? "N/A",
            "bookingDate": formatDateTime(booking.scheduledAt),
            "car":
                booking.vehicleInfo != null
                    ? "${booking.vehicleInfo?.brand ?? ''}  ${booking.vehicleInfo?.model ?? ''} | ${booking.vehicleInfo?.registrationNumber ?? ''}"
                    : "N/A",
            "estimatedDuration": "1.5 Hours",
            "serviceType": booking.serviceType ?? "-",
            "paymentMethod": booking.paymentMode ?? "-",
            "transactionDate": formatDateTime(booking.scheduledAt),

            // "taxFees": "Rs. 35.00",
            "total": "Rs. ${originalAmount.toStringAsFixed(2)}",
            "promoCode": booking.promoCodeInfo?['code'] ?? "-",
            "discount": "- Rs. ${discountAmount.toStringAsFixed(2)}",
            "totalPaid":
                "Rs. ${booking.totalCharges?.toStringAsFixed(2) ?? '0.00'}",
          };

          final serviceWidgets =
              booking.services?.map((service) {
                return _buildInfoRow(
                  service.name ?? "Service",
                  "Rs. ${service.price.toStringAsFixed(2)}",
                );
              }).toList() ??
              [];

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => context.pop(),
              ),
              title: const Text(
                "E-Receipt",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (receiptData["transactionId"] != null)
                          Center(
                            child: BarcodeWidget(
                              barcode: Barcode.code128(),
                              data: receiptData["transactionId"]!,
                              width: 250,
                              height: 60,
                            ),
                          ),
                        const SizedBox(height: 20),
                        _buildInfoRow(
                          "Booking Date",
                          receiptData["bookingDate"],
                        ),
                        _buildInfoRow("Car", receiptData["car"]),
                        _buildInfoRow(
                          "Estimated Service Duration",
                          receiptData["estimatedDuration"],
                        ),
                        _buildInfoRow(
                          "Service Type",
                          receiptData["serviceType"],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Divider(thickness: 1, height: 20),
                        ),
                        ...serviceWidgets,
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Divider(thickness: 1, height: 20),
                        ),
                        _buildInfoRow("Total", receiptData["total"]),
                        _buildInfoRow("Promo Code", receiptData["promoCode"]),
                        _buildInfoRow("Discount", receiptData["discount"]),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Divider(thickness: 1, height: 20),
                        ),
                        _buildInfoRow(
                          "Total Paid",
                          receiptData["totalPaid"],
                          isBold: true,
                        ),

                        _buildInfoRow(
                          "Payment Methods",
                          receiptData["paymentMethod"],
                        ),
                        _buildInfoRow("Date", receiptData["transactionDate"]),
                        _buildInfoRow(
                          "Transaction Id",
                          receiptData["transactionId"],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // context.push("/e-receipt/${widget.bookingId}");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text(
                          "Download E-Receipt",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          context.go("/home");
                        },
                        child: const Text(
                          "Go to Home",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return const Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: Text("No booking data available.")),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String? value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(
            value ?? "-",
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
