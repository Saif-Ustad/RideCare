import 'package:flutter/material.dart';

import '../../../core/configs/theme/app_colors.dart';

class ChooseServicesSection extends StatelessWidget {
  const ChooseServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Column(
        children: [
          _buildSectionHeader("Choose Services"),
          SizedBox(height: 10),
          Row(
            children: [
              // Big Left Card
              Expanded(
                flex: 1,
                child: _buildBigServiceCard(
                  title: "Diagnostic Services",
                  subtitle: "Temper erat elit elbum",
                  icon: Icons.calendar_today,
                ),
              ),
              SizedBox(width: 10),

              // Right side smaller cards
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildSmallServiceCard(
                      title: "Repairs",
                      subtitle: "Temper erat elit",
                      icon: Icons.build,
                    ),
                    SizedBox(height: 10),
                    _buildSmallServiceCard(
                      title: "Car Wash",
                      subtitle: "Temper erat elit",
                      icon: Icons.directions_car,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }



  Widget _buildSectionHeader(String title) {
    return Row(
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
        Text(
          "See All",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }


  /// **Big Left Card (Icon on Top, Text Below)**
  Widget _buildBigServiceCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(10),
      ),
      height: 140,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 20,
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 10, color: AppColors.darkGrey),
          ),
        ],
      ),
    );
  }

  /// **Small Right Cards (Icon Left, Text Right)**
  Widget _buildSmallServiceCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(10),
      ),
      height: 65,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 18,
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 10, color: AppColors.darkGrey),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
