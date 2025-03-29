import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ridecare/core/configs/assets/app_images.dart';
import 'package:ridecare/presentation/serviceProvider/pages/aboutTab.dart';
import 'package:ridecare/presentation/serviceProvider/pages/galleryTab.dart';
import 'package:ridecare/presentation/serviceProvider/pages/reviewTab.dart';
import 'package:ridecare/presentation/serviceProvider/pages/servicesTab.dart';

import '../../../common/widgets/bottomBar/bottomBar.dart';
import '../widgets/headerSection.dart';
import '../widgets/serviceInfoSection.dart';
import '../widgets/tabSection.dart';

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
                    aboutText:
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
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
            CustomBottomBar(
              text: "Book Service Now",
              onPressed: () {
                context.push("/choose-service");
              },
            ),
          ],
        ),
      ),
    );
  }
}
