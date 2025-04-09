import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:ridecare/domain/entities/address_entity.dart';
import 'package:ridecare/presentation/booking/bloc/booking_bloc.dart';
import 'package:ridecare/presentation/booking/bloc/booking_event.dart';

import '../../../common/widgets/bottomBar/bottomBar.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../bloc/address_bloc.dart';
import '../bloc/address_event.dart';
import '../bloc/address_state.dart';

class SelectLocationPage extends StatefulWidget {
  const SelectLocationPage({super.key});

  @override
  _SelectLocationPageState createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  String? selectedAddress;

  @override
  void initState() {
    super.initState();
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      context.read<AddressBloc>().add(LoadAddresses(uid));
    }
  }

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
              child: BlocBuilder<AddressBloc, AddressState>(
                builder: (context, state) {
                  if (state is AddressLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AddressLoaded) {
                    final addresses = state.addresses;
                    return ListView(
                      children: [
                        ...addresses
                            .map((address) => _buildAddressTile(address))
                            .toList(),
                        _buildAddAddressButton(),
                      ],
                    );
                  } else if (state is AddressError) {
                    return Center(
                      child: Text(
                        'Failed to load addresses: ${state.message}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  return const Center(child: Text("No addresses found."));
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        text: "Continue",
        onPressed: () {
          final addressId = selectedAddress;
          if (addressId != null) {
            context.read<BookingBloc>().add(SetAddress(addressId: addressId));
            context.push("/bill-summary/1");
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please select a address")),
            );
          }
        },
      ),
    );
  }

  Widget _buildAddressTile(AddressEntity address) {
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
            address.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            address.address,
            style: const TextStyle(fontSize: 14, color: AppColors.darkGrey),
          ),
          trailing: Radio<String>(
            value: address.id,
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
