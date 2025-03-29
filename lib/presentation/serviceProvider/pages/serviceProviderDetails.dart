import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ridecare/core/configs/assets/app_images.dart';
import 'package:ridecare/presentation/serviceProvider/pages/aboutTab.dart';
import 'package:ridecare/presentation/serviceProvider/pages/galleryTab.dart';
import 'package:ridecare/presentation/serviceProvider/pages/reviewTab.dart';
import 'package:ridecare/presentation/serviceProvider/pages/servicesTab.dart';

import '../../../common/widgets/bottomBar/bottomBar.dart';
import '../../../core/configs/theme/app_colors.dart';

class ServiceProviderDetailPage extends StatefulWidget {
  const ServiceProviderDetailPage({super.key});

  @override
  _ServiceProviderDetailPageState createState() =>
      _ServiceProviderDetailPageState();
}

class _ServiceProviderDetailPageState extends State<ServiceProviderDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> images = List.filled(7, AppImages.serviceProvider1);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            HeaderSection(images: images),
            const SizedBox(height: 12),
            const ServiceInfoSection(),
            const SizedBox(height: 12),
            TabSection(tabController: _tabController),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  const AboutTab(
                    aboutText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                    userName: "Rohit Patil",
                    userRole: "Service Provider",
                    userImage: AppImages.serviceProviderProfile1,
                    rating: 4.5,
                    experience: "5 Years",
                    location: "Pune, India",
                    availability: "9 AM - 6 PM",
                  ),
                  ServicesTab(),
                  GalleryTab(),
                  ReviewTab(),
                ],
              ),
            ),
            CustomBottomBar(text: "Book Service Now", onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  final List<String> images;

  const HeaderSection({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          AppImages.serviceProvider1,
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.3,
          fit: BoxFit.cover,
        ),
        Positioned(
          top: 10,
          left: 10,
          child: _iconButton(Icons.arrow_back, () => context.pop()),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Row(
            children: [
              _iconButton(Icons.share, () => {}),
              const SizedBox(width: 10),
              _iconButton(Icons.bookmark_border, () => {}),
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          left: MediaQuery.of(context).size.width * 0.1,
          right: MediaQuery.of(context).size.width * 0.1,
          child: _buildGalleryThumbnails(),
        ),
      ],
    );
  }

  Widget _buildGalleryThumbnails() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(4),
      height: 50,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length > 5 ? 5 : images.length,
        itemBuilder: (context, index) {
          bool isLastImage = index == 4 && images.length > 5;
          return Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    images[index],
                    width: 55,
                    height: 55,
                    fit: BoxFit.cover,
                  ),
                ),
                if (isLastImage)
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        "+${images.length - 5}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      height: 40,
      width: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.black, size: 20),
        onPressed: onPressed,
      ),
    );
  }
}

class ServiceInfoSection extends StatelessWidget {
  const ServiceInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.lightGray,
                ),
                child: Text(
                  'Car Service',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.star, color: Colors.amber, size: 18),
              const SizedBox(width: 5),
              const Text('4.8 (365 reviews)', style: TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bajaj Service Center',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '1023, Kondhwa bk, Pune',
                      style: TextStyle(color: AppColors.darkGrey, fontSize: 14),
                    ),
                  ],
                ),
              ),
              Icon(Icons.telegram, size: 45, color: AppColors.primary),
            ],
          ),
        ],
      ),
    );
  }
}

class TabSection extends StatelessWidget {
  final TabController tabController;

  const TabSection({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      labelColor: AppColors.primary,
      unselectedLabelColor: Colors.grey,
      indicatorColor: AppColors.primary,
      labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      tabs: const [
        Tab(text: 'About'),
        Tab(text: 'Services'),
        Tab(text: 'Gallery'),
        Tab(text: 'Review'),
      ],
    );
  }
}
