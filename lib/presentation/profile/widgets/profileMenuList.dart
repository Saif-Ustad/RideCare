import 'package:flutter/material.dart';
import 'package:ridecare/presentation/profile/widgets/profileMenuItem.dart';

class ProfileMenuList extends StatelessWidget {
  const ProfileMenuList({super.key});

  final List<Map<String, dynamic>> _menuItems = const [
    {'icon': Icons.person, 'title': "Your Profile"},
    {'icon': Icons.location_on, 'title': "Manage Address"},
    {'icon': Icons.credit_card, 'title': "Payment Methods"},
    {'icon': Icons.calendar_today, 'title': "My Bookings"},
    {'icon': Icons.account_balance_wallet, 'title': "Wallet"},
    {'icon': Icons.settings, 'title': "Settings"},
    {'icon': Icons.headset_mic, 'title': "Help Center"},
    {'icon': Icons.privacy_tip, 'title': "Privacy Policy"},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _menuItems.length,
      itemBuilder: (context, index) {
        return ProfileMenuItem(
          icon: _menuItems[index]['icon'],
          title: _menuItems[index]['title'],
        );
      },
    );
  }
}
