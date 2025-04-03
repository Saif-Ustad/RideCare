import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../../common/widgets/bottomBar/bottomBar.dart';
import '../../../core/configs/theme/app_colors.dart';

class SelectLocationPage extends StatefulWidget {
  const SelectLocationPage({super.key});

  @override
  _SelectLocationPageState createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  String? selectedAddress;

  final List<Map<String, String>> addresses = [
    {"title": "Home", "details": "1002, Anand Nager, Kudnur 416508"},
    {"title": "Office", "details": "231, Dmart road, Baner, Pune 411008"},
    {
      "title": "Friend’s House",
      "details": "102, Laxmi Nagar lane no - 10, Kondhwa BK, Pune ",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _buildLeadingIconButton(() => context.pop()),
        title: const Text(
          "Pick Up & Delivery Address",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Address",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView(
                children: [
                  ...addresses
                      .map((address) => _buildAddressTile(address))
                      .toList(),
                  _buildAddAddressButton(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        text: "Continue",
        onPressed: () {
          context.push("/bill-summary/1");
        },
      ),
    );
  }

  Widget _buildAddressTile(Map<String, String> address) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          leading: const Icon(
            Icons.location_on,
            size: 30,
            color: AppColors.primary,
          ),
          title: Text(
            address["title"]!,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            address["details"]!,
            style: const TextStyle(fontSize: 14, color: AppColors.darkGrey),
          ),
          trailing: Radio<String>(
            value: address["title"]!,
            groupValue: selectedAddress,
            onChanged: (value) {
              setState(() {
                selectedAddress = value;
              });
            },
            activeColor: AppColors.primary,
          ),
        ),
        const Divider(color: AppColors.lightGray, thickness: 1, height: 5),
      ],
    );
  }

  /// Widget to Add New Address with Dashed Border
  Widget _buildAddAddressButton() {
    return GestureDetector(
      onTap: () {
       context.push("/add-location");
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: DottedBorder(
          color: AppColors.primary,
          strokeWidth: 1.5,
          borderType: BorderType.RRect,
          radius: const Radius.circular(8),
          dashPattern: [6, 4],
          child: Container(
            height: 55,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: AppColors.primary, size: 24),
                const SizedBox(width: 8),
                const Text(
                  "Add Address",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
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
        icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
        onPressed: onPressed,
        constraints: const BoxConstraints(),
        padding: EdgeInsets.zero,
      ),
    ),
  );
}
