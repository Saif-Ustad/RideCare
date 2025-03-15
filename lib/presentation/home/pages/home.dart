import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ridecare/core/configs/assets/app_images.dart';
import 'package:ridecare/core/configs/theme/app_colors.dart';
import 'package:ridecare/presentation/home/widgets/specialOfferCarousel.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<String> carouselImages = [
    AppImages.specialOffer1,
    AppImages.specialOffer1,
    AppImages.specialOffer1,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                expandedHeight: 130.0,
                floating: false,
                pinned: true,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(15),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                      left: 20,
                      right: 20,
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLocationInfo(),
                        _buildNotificationIcon(),
                      ],
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(15),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    child: Row(
                      children: [
                        Expanded(child: _buildSearchBox()),
                        SizedBox(width: 10),
                        _buildFilterIcon(),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader("#SpecialForYou"),
                      SizedBox(height: 10),
                      SpecialOfferCarousel(),
                      SizedBox(height: 20),
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
                      SizedBox(height: 20),
                      _buildSectionHeader("Popular Services Provider"),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomNavigationBar(),
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

  Widget _buildNotificationIcon({bool hasNotification = true}) {
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
            onPressed: () {},
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

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
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

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 0,
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
        BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Bookmark"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
