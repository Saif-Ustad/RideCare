import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridecare/presentation/profile/widgets/profileMenuItem.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';

class ProfileMenuList extends StatelessWidget {
  const ProfileMenuList({super.key});

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
    {'icon': Icons.account_balance_wallet, 'title': "Wallet", 'route': ""},
    {'icon': Icons.settings, 'title': "Settings", 'route': ""},
    {'icon': Icons.headset_mic, 'title': "Help Center", 'route': ""},
    {'icon': Icons.privacy_tip, 'title': "Privacy Policy", 'route': ""},
    {'icon': Icons.logout, 'title': "Logout", 'route': "", 'isLogout': true},
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
          onTap:
              _menuItems[index]['isLogout'] == true
                  ? () {
                    context.read<AuthBloc>().add(LogoutEvent());
                  }
                  : null,
        );
      },
    );
  }
}
