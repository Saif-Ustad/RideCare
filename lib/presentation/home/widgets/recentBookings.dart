import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../booking/bloc/booking_bloc.dart';
import '../../booking/bloc/booking_state.dart';

class RecentBookingsSection extends StatelessWidget {
  const RecentBookingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, "My Recent Bookings"),
          SizedBox(height: 15),
          // BlocBuilder to listen to BookingState changes
          BlocBuilder<BookingBloc, BookingState>(
            builder: (context, state) {
              if (state is BookingLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is BookingError) {
                return Center(child: Text("Error: ${state.message}"));
              } else if (state is BookingsLoaded) {
                if (state.bookings.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Bookings Found",
                      style: TextStyle(fontSize: 14, color: AppColors.grey),
                    ),
                  );
                }

                final recentBookings =
                    state.bookings
                        .where(
                          (booking) =>
                              booking.status?.toLowerCase() !=
                              'Order Cancelled',
                        )
                        .take(3)
                        .toList();

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: recentBookings.length,
                  itemBuilder: (context, index) {
                    final booking = recentBookings[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            spreadRadius: 2,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 3,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          child: Icon(Icons.history, color: AppColors.primary),
                        ),
                        title: Text(
                          booking.services?.map((e) => e.name).join(", ") ??
                              "Unknown Service",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        subtitle: Text(
                          "Booked: ${_formatDate(booking.scheduledAt)}",
                          style: TextStyle(
                            color: AppColors.darkGrey,
                            fontSize: 12,
                          ),
                        ),
                        trailing: InkWell(
                          onTap: () {
                            // Handle Re-book action
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.deepPurple,
                                  Colors.purpleAccent,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                context.push(
                                  '/service-provider/${booking.serviceProviderId}',
                                );
                              },
                              child: Text(
                                "Re-book",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: Text("No bookings available"));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          GestureDetector(
            onTap: () {
              context.push('/my-bookings');
            },
            child: Text(
              "See All",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to format the scheduledAt date
  String _formatDate(DateTime? date) {
    if (date == null) return "Unknown Date";
    final difference = DateTime.now().difference(date);
    if (difference.inDays < 1) return "${difference.inHours} hours ago";
    if (difference.inDays == 1) return "Yesterday";
    return "${difference.inDays} days ago";
  }
}
