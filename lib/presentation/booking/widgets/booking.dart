import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';

class Booking {
  final String serviceCenter, orderId, orderDate, imageUrl, status, btn1, btn2;
  final double distance, time, payment;
  final Color statusColor;
  final Function(BuildContext)? btn1OnPressed, btn2OnPressed; // Accept context

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
    this.btn1OnPressed,
    this.btn2OnPressed,
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
    btn1: "Cancel",
    btn2: "Track Order",
    btn1OnPressed: (context) {},
    btn2OnPressed: (context) {
      context.push("/track-order/1");
    },
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
    btn1: "Cancel",
    btn2: "Track Order",
    btn1OnPressed: (context) {},
    btn2OnPressed: (context) {
      context.push("/track-order/1");
    },
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
    btn2: "E-Receipt",
    btn1OnPressed: (context) {},
    btn2OnPressed: (context) {
      context.push("/e-receipt");
    },
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
    btn2: "E-Receipt",
    btn1OnPressed: (context) {},
    btn2OnPressed: (context) {
      context.push("/e-receipt");
    },
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
    btn1: "",
    btn2: "",
    btn1OnPressed: (context) {},
    btn2OnPressed: (context) {},
  ),
];
