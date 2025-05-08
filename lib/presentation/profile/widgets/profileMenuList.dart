import 'package:flutter/material.dart';
import 'package:ridecare/presentation/profile/widgets/profileMenuItem.dart';

class ProfileMenuList extends StatelessWidget {
  final VoidCallback onLogoutPressed;

  const ProfileMenuList({super.key, required this.onLogoutPressed});

  final List<Map<String, dynamic>> _menuItems = const [
    {'icon': Icons.person, 'title': "Your Profile", 'route': "/your-profile/1"},
    {
      'icon': Icons.location_on,
      'title': "Manage Address",
      'route': "/select-location-profile",
    },
    {
      'icon': Icons.car_repair,
      'title': "Manage Vehicles",
      'route': "/select-vehicle-profile",
    },
    {
      'icon': Icons.calendar_today,
      'title': "My Bookings",
      'route': "/my-bookings",
    },
    {
      'icon': Icons.account_balance_wallet,
      'title': "Wallet",
      'route': "/wallet",
    },
    {'icon': Icons.settings, 'title': "Settings", 'route': ""},
    {'icon': Icons.share, 'title': "Refer & Earn", 'route': "/refer-earn"},
    {
      'icon': Icons.headset_mic,
      'title': "Help Center",
      'route': "/help-center",
    },
    {'icon': Icons.privacy_tip, 'title': "Privacy Policy", 'route': ""},
    {'icon': Icons.logout, 'title': "Logout", 'route': "", 'isLogout': true},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _menuItems.length,
      itemBuilder: (context, index) {
        final item = _menuItems[index];
        final isLogout = item['isLogout'] == true;

        return ProfileMenuItem(
          icon: item['icon'],
          title: item['title'],
          route: item['route'],
          onTap: isLogout ? onLogoutPressed : null,
        );
      },
    );
  }
}
