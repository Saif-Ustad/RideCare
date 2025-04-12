import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ridecare/domain/entities/service_provider_entity.dart';
import 'package:ridecare/presentation/booking/bloc/booking_event.dart';
import '../../../common/widgets/bottomBar/bottomBar.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../booking/bloc/booking_bloc.dart';
import '../../booking/bloc/booking_state.dart';
import 'package:intl/intl.dart';

import '../bloc/promoCode/promo_code_bloc.dart';
import '../bloc/promoCode/promo_code_event.dart';
import '../bloc/promoCode/promo_code_state.dart';

class BillSummaryPage extends StatefulWidget {
  const BillSummaryPage({super.key});

  @override
  State<BillSummaryPage> createState() => _BillSummaryPageState();
}

class _BillSummaryPageState extends State<BillSummaryPage> {
  final TextEditingController _promoCodeController = TextEditingController();
  String? _appliedPromo;
  double _discount = 0.0;

  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(PrepareBillSummary());
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
        child: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            if (state is BookingUpdated) {
              final booking = state.booking;

              final services = booking.services ?? [];
              double originalTotal = services.fold<double>(
                0.0,
                (sum, service) => sum + (service.price ?? 0),
              );

              final discountedTotal = originalTotal - (originalTotal * _discount)/100;

              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            booking.serviceProvider != null
                                ? _buildServiceCenterDetails(
                                  booking.serviceProvider!,
                                )
                                : const Text("Service provider not available"),

                            const Divider(thickness: 1, height: 20),
                            _buildSummaryDetails(
                              booking,
                              services,
                              originalTotal,
                              discountedTotal,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (booking.serviceProvider != null)
                      _buildPromoCodeSection(booking.serviceProvider!),
                  ],
                ),
              );
            } else if (state is BookingLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BookingError) {
              return Center(child: Text("Error: ${state.message}"));
            } else {
              return const SizedBox();
            }
          },
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

  Widget _buildServiceCenterDetails(ServiceProviderEntity serviceCenter) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: serviceCenter.workImageUrl,
            width: 150,
            height: 100,
            fit: BoxFit.cover,
            placeholder:
                (context, url) =>
                    const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
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
                    "Car Repairs",
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
                  "1.5 km ",
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
                  "8 mins",
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
    booking,
    List services,
    double originalTotal,
    double discountedTotal,
  ) {
    final date =
        booking.scheduledAt != null
            ? DateFormat("MMM dd, yyyy").format(booking.scheduledAt!)
            : "Not Set";

    final carDetails =
        "${booking.vehicle?.brand} ${booking.vehicle?.type ?? "Vehicle"} | ${booking.vehicle?.registrationNumber ?? "Not Available"}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSummaryRow("Booking Date", date),
        _buildSummaryRow("Car", carDetails),
        _buildSummaryRow("Service Type", booking.serviceType ?? "N/A"),
        const Divider(thickness: 1),
        ...services.map<Widget>(
          (s) => _buildSummaryRow(s.name ?? "", "Rs. ${s.price ?? 0}"),
        ),
        if (_appliedPromo != null)
          _buildSummaryRow("Promo Applied", _appliedPromo!),
        if (_discount > 0) _buildSummaryRow("Discount", "- Rs. ${(originalTotal * _discount)/100}"),
        const Divider(thickness: 1, color: Colors.grey),
        _buildSummaryRow("Total", "Rs. $discountedTotal", isBold: true),
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

  Widget _buildPromoCodeSection(ServiceProviderEntity serviceProvider) {
    return BlocConsumer<PromoCodeBloc, PromoCodeState>(
      listener: (context, state) {
        if (state is PromoCodeApplied) {
          final promo = state.promoCode;
          final now = DateTime.now();
          if (promo.validUntil.isAfter(now) &&
              promo.applicableServiceProviderIds.contains(serviceProvider.id)) {
            setState(() {
              _appliedPromo = promo.code;
              _discount = promo.discountPercentage;
            });

            // Dispatch ApplyPromoCode event to BookingBloc
            context.read<BookingBloc>().add(
              ApplyPromoCode(
                promoCode: promo.code,
                discountPercentage: promo.discountPercentage,
              ),
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Promo code applied successfully")),
            );
          } else {
            setState(() {
              _appliedPromo = null;
              _discount = 0;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Promo code is not valid or expired"),
              ),
            );
          }
        } else if (state is PromoCodeInvalid) {
          setState(() {
            _appliedPromo = null;
            _discount = 0;
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Invalid promo code")));
        }
      },
      builder: (context, state) {
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
                controller: _promoCodeController,
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
              onPressed:
                  () => _applyPromo(
                    _promoCodeController.text.trim(),
                    serviceProvider.id,
                  ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 12,
                ),
              ),
              child: const Text("Apply", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _applyPromo(String code, String serviceProviderId) {
    context.read<PromoCodeBloc>().add(
      ApplyPromoCodeEvent(code: code, serviceProviderId: serviceProviderId),
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
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
        onPressed: onPressed,
      ),
    ),
  );
}
