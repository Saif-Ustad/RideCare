// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:ridecare/common/widgets/bottomBar/bottomBar.dart';
//
// import '../../../core/configs/theme/app_colors.dart';
// import '../widgets/orderStep.dart';
//
// class TrackOrderPage extends StatelessWidget {
//   const TrackOrderPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: _buildLeadingIconButton(() => context.pop()),
//         title: const Text(
//           "Track Order",
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w500,
//             color: Colors.black,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 10),
//
//             // Order ID
//             const Text(
//               "Order #CRD3275A56",
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             // Timeline
//             Expanded(
//               child: ListView(
//                 children: const [
//                   OrderStep(
//                     title: "Order Accepted",
//                     time: "4 Mar 2025, 10:00 AM",
//                     isCompleted: true,
//                   ),
//                   OrderStep(
//                     title: "Car Received at Center",
//                     time: "4 Mar 2025, 12:10 PM",
//                     isCompleted: true,
//                   ),
//                   OrderStep(
//                     title: "Order in Progressed",
//                     time: "4 Mar 2025, 1:40 PM",
//                     isCompleted: true,
//                   ),
//                   OrderStep(
//                     title: "Ready for Pick or Delivery",
//                     time: "4 Mar 2025, 3:25 PM",
//                     isCompleted: true,
//                   ),
//                   OrderStep(
//                     title: "Delivered",
//                     time: "Expected 4 Mar 2025, 5:05 PM",
//                     isCompleted: false,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: CustomBottomBar(
//         text: "Track Live Location",
//         onPressed: () => {},
//       ),
//     );
//   }
//
//   Widget _buildLeadingIconButton(VoidCallback onPressed) => Padding(
//     padding: const EdgeInsets.only(left: 15),
//     child: Container(
//       height: 40,
//       width: 40,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         border: Border.all(color: AppColors.darkGrey, width: 1),
//       ),
//       child: IconButton(
//         icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
//         onPressed: onPressed,
//       ),
//     ),
//   );
// }
//

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ridecare/presentation/booking/bloc/booking_tracking_bloc/booking_tracking_event.dart';

import '../../../common/widgets/bottomBar/bottomBar.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../bloc/booking_tracking_bloc/booking_tracking_bloc.dart';
import '../bloc/booking_tracking_bloc/booking_tracking_state.dart';
import '../widgets/orderStep.dart';

class TrackOrderPage extends StatelessWidget {
  final String bookingId;

  const TrackOrderPage({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    context.read<BookingTrackingBloc>().add(GetBookingTrackingInfo(bookingId));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _buildLeadingIconButton(() => context.pop()),
        title: const Text(
          "Track Order",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BlocBuilder<BookingTrackingBloc, BookingTrackingState>(
          builder: (context, state) {
            if (state is BookingTrackingLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BookingTrackingLoaded) {
              final updates = state.tracking.updates;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Order ID
                  Text(
                    "Booking #${state.tracking.bookingId}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: ListView.builder(
                      itemCount: updates.length,
                      itemBuilder: (context, index) {
                        final step = updates[index];
                        final currentTime = DateTime.now();
                        final isCompleted = step.timestamp.isBefore(currentTime);
                        return OrderStep(
                          title: step.status,
                          time:
                              "${step.timestamp.day} ${_month(step.timestamp.month)} ${step.timestamp.year}, ${_formatTime(step.timestamp)}",
                          isCompleted: isCompleted,
                        );
                      },
                    ),
                  ),
                ],
              );
            } else if (state is BookingTrackingError) {
              return Center(child: Text(state.message));
            }

            return const SizedBox.shrink(); // Fallback
          },
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        text: "Track Live Location",
        onPressed: () {
          // TODO: Implement live tracking
        },
      ),
    );
  }

  String _formatTime(DateTime dt) {
    return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} ${dt.hour < 12 ? 'AM' : 'PM'}";
  }

  String _month(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month];
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
