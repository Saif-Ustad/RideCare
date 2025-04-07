import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ridecare/core/configs/assets/app_images.dart';
import 'package:ridecare/presentation/serviceProvider/bloc/service_event.dart';
import 'package:ridecare/presentation/serviceProvider/pages/aboutTab.dart';
import 'package:ridecare/presentation/serviceProvider/pages/galleryTab.dart';
import 'package:ridecare/presentation/serviceProvider/pages/reviewTab.dart';
import 'package:ridecare/presentation/serviceProvider/pages/servicesTab.dart';

import '../../../common/widgets/bottomBar/bottomBar.dart';
import '../../home/bloc/serviceProvider/service_provider_bloc.dart';
import '../../home/bloc/serviceProvider/service_provider_state.dart';
import '../bloc/service_bloc.dart';
import '../widgets/headerSection.dart';
import '../widgets/serviceInfoSection.dart';
import '../widgets/tabSection.dart';

class ServiceProviderDetailPage extends StatefulWidget {
  final String id;

  const ServiceProviderDetailPage({super.key, required this.id});

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
    _loadData();
  }

  Future<void> _loadData() async {
    context.read<ServiceBloc>().add(FetchAllServiceForProvider(widget.id));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceProviderBloc, ServiceProviderState>(
      builder: (context, state) {
        if (state is ServiceProviderLoaded) {
          final provider = state.providers.firstWhere(
            (element) => element.id == widget.id,
            orElse: () => throw Exception('Provider not found'),
          );

          return Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Column(
                children: [
                  HeaderSection(images: images, provider: provider),
                  const SizedBox(height: 12),
                  ServiceInfoSection(provider: provider),
                  const SizedBox(height: 12),
                  TabSection(tabController: _tabController),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        AboutTab(
                          aboutText: provider.about,
                          userName: provider.name,
                          userRole: "Service Provider",
                          userImage: provider.profileImageUrl,
                          rating: provider.rating,
                          experience: provider.experienceYears,
                          location: provider.location,
                          availability: provider.availability,
                          phoneNumber: provider.contactPhone,
                        ),
                        ServicesTab(),
                        GalleryTab(galleryImages: provider.galleryImageUrls),
                        ReviewTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: CustomBottomBar(
              text: "Book Service Now",
              onPressed: () {
                context.push("/choose-service");
              },
            ),
          );
        } else if (state is ServiceProviderLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ServiceProviderError) {
          return Center(child: Text(state.message));
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
