import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:ridecare/core/configs/theme/app_colors.dart';

class EReceiptPage extends StatefulWidget {
  const EReceiptPage({super.key});

  @override
  _EReceiptPageState createState() => _EReceiptPageState();
}

class _EReceiptPageState extends State<EReceiptPage> {
  Map<String, String> receiptData = {};

  @override
  void initState() {
    super.initState();
    _loadReceiptData(); // Load data when the page initializes
  }

  void _loadReceiptData() {
    // Simulating an API call or fetching from shared state
    setState(() {
      receiptData = {
        "transactionId": "TR4365HGJKL",
        "bookingDate": "Mar 04, 2025 | 10:00 AM",
        "car": "SUV | MH 09 ER 65XX",
        "estimatedDuration": "1.5 Hours",
        "serviceType": "Pick-Up",
        "wax": "Rs. 250.00",
        "scratchRemoval": "Rs. 750.00",
        "taxFees": "Rs. 35.00",
        "total": "Rs. 1035.00",
        "paymentMethod": "Cash",
        "transactionDate": "Mar 04, 2025 | 10:00 AM",
      };
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: receiptData.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Show loader until data is loaded
          : Padding(
        padding: const EdgeInsets.all(15.0),
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

            _buildInfoRow("Booking Date", receiptData["bookingDate"]),
            _buildInfoRow("Car", receiptData["car"]),
            _buildInfoRow("Estimated Service Duration", receiptData["estimatedDuration"]),
            _buildInfoRow("Service Type", receiptData["serviceType"]),
            const Divider(thickness: 1, height: 20),

            _buildInfoRow("Wax", receiptData["wax"]),
            _buildInfoRow("Scratch Removal", receiptData["scratchRemoval"]),
            _buildInfoRow("Tax & Fees", receiptData["taxFees"]),
            const Divider(thickness: 1, height: 20),

            _buildInfoRow("Total", receiptData["total"], isBold: true),
            const SizedBox(height: 10),

            _buildInfoRow("Payment Methods", receiptData["paymentMethod"]),
            _buildInfoRow("Date", receiptData["transactionDate"]),
            _buildInfoRow("Transaction Id", receiptData["transactionId"]),
            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Add download functionality
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "Download E-Receipt",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String? value, {bool isBold = false}) {
    if (value == null || value.isEmpty) return const SizedBox(); // Hide if no data

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: isBold ? Colors.black : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
