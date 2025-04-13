import 'package:flutter/material.dart';
import 'package:ridecare/presentation/profile/widgets/profileMenuItem.dart';

class ProfileMenuList extends StatelessWidget {
  const ProfileMenuList({super.key});

  final List<Map<String, dynamic>> _menuItems = const [
    {'icon': Icons.person, 'title': "Your Profile", 'route' : ""},
    {'icon': Icons.location_on, 'title': "Manage Address", 'route' : "/select-location"},
    {'icon': Icons.car_repair, 'title': "Manage Vehicles", 'route' : "/select-vehicle"},
    {'icon': Icons.calendar_today, 'title': "My Bookings", 'route' : "/my-bookings"},
    {'icon': Icons.account_balance_wallet, 'title': "Wallet", 'route' : ""},
    {'icon': Icons.settings, 'title': "Settings", 'route' : ""},
    {'icon': Icons.headset_mic, 'title': "Help Center", 'route' : ""},
    {'icon': Icons.privacy_tip, 'title': "Privacy Policy", 'route' : ""},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _menuItems.length,
      itemBuilder: (context, index) {
        return ProfileMenuItem(
          icon: _menuItems[index]['icon'],
          title: _menuItems[index]['title'],
          route: _menuItems[index]['route'],
        );
      },
    );
  }
}
