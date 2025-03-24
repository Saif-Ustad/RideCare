import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:ridecare/domain/usecases/sign_out.dart';

import '../../../core/configs/theme/app_colors.dart';


class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      expandedHeight: 130.0,
      floating: false,
      pinned: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildLocationInfo(), _buildNotificationIcon(context)],
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Row(
            children: [
              Expanded(child: _buildSearchBox()),
              SizedBox(width: 10),
              _buildFilterIcon(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Location",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
        Row(
          children: [
            Icon(Icons.location_on, color: AppColors.orange, size: 22),
            SizedBox(width: 2),
            Text(
              "Kondhwa, Pune",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.white, size: 26),
          ],
        ),
      ],
    );
  }

  Widget _buildNotificationIcon(BuildContext context, {bool hasNotification = true}) {
    return Stack(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: Color(0xFF8A6CFF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () async {
              final signOutUseCase = GetIt.instance<SignOut>();
              await signOutUseCase();

              if (context.mounted) {  // Ensure context is valid
                GoRouter.of(context).go('/signin'); // Redirect to Sign-In Page
              }
            },
          ),
        ),

        // Red Dot (Badge)
        if (hasNotification)
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              height: 8,
              width: 8,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSearchBox() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          color: AppColors.black,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: "Search location",
          hintStyle: TextStyle(
            color: AppColors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
          prefixIcon: Icon(Icons.location_on, color: AppColors.primary),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 10, bottom: 10),
        ),
      ),
    );
  }

  Widget _buildFilterIcon() {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(Icons.filter_list, color: AppColors.primary),
        onPressed: () {},
      ),
    );
  }
}
