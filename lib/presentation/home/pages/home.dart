import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ridecare/common/widgets/bottomNavigationBar/bottomNavigationBar.dart';
import 'package:ridecare/core/configs/theme/app_colors.dart';
import 'package:ridecare/presentation/home/widgets/HomeAppBar.dart';
import 'package:ridecare/presentation/home/widgets/chooseCategory.dart';
import 'package:ridecare/presentation/home/widgets/popularServiceProvider.dart';
import 'package:ridecare/presentation/home/widgets/specialOfferCarousel.dart';
import '../../../common/helper/saveUserLocationToPrefs.dart';
import '../../bookmark/bloc/bookmark_bloc.dart';
import '../../bookmark/bloc/bookmark_event.dart';
import '../../vehicles/bloc/vehicle_bloc.dart';
import '../../vehicles/bloc/vehicle_event.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_event.dart';
import '../bloc/notification/notification_bloc.dart';
import '../bloc/notification/notification_event.dart';
import '../bloc/serviceProvider/service_provider_bloc.dart';
import '../bloc/serviceProvider/service_provider_event.dart';
import '../bloc/specialOffers/special_offer_bloc.dart';
import '../bloc/specialOffers/special_offer_event.dart';
import '../bloc/user/user_bloc.dart';
import '../bloc/user/user_event.dart';
import '../bloc/user/user_state.dart';
import '../widgets/exclusiveMembership.dart';
import '../widgets/recentBookings.dart';
import '../widgets/refer&Earn.dart';
import '../widgets/topReviewsAndRatings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isNavBarVisible = true;

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(LoadUserEvent());
    context.read<SpecialOfferBloc>().add(FetchSpecialOffers());
    // context.read<ServiceProviderBloc>().add(
    //   FetchAllServiceProvidersWithoutLocation(),
    // );
    context.read<CategoryBloc>().add(FetchCategories());

    _getCurrentLocationAndFetchProviders();

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isNavBarVisible) {
          setState(() => _isNavBarVisible = false);
        }
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_isNavBarVisible) {
          setState(() => _isNavBarVisible = true);
        }
      }
    });
  }

  Future<void> _getCurrentLocationAndFetchProviders({
    bool fromRefresh = false,
  }) async {
    try {
      if (!fromRefresh) {
        final savedLocation = await getUserLocationFromPrefs();
        if (savedLocation != null) {
          context.read<ServiceProviderBloc>().add(
            FetchAllServiceProviders(
              savedLocation.latitude,
              savedLocation.longitude,
            ),
          );
          return;
        }
      }

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await _showLocationDialog();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) {
        await _showPermissionDialog();
        return;
      }

      // Get location and save to prefs
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      await saveUserLocationToPrefs(position.latitude, position.longitude);

      if (mounted) {
        context.read<ServiceProviderBloc>().add(
          FetchAllServiceProviders(position.latitude, position.longitude),
        );
      }
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  Future<void> _onRefresh() async {
    context.read<UserBloc>().add(LoadUserEvent());
    context.read<SpecialOfferBloc>().add(FetchSpecialOffers());
    context.read<CategoryBloc>().add(FetchCategories());
    await _getCurrentLocationAndFetchProviders(fromRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserLoaded) {
          final currentUser = state.user;
          context.read<BookmarkBloc>().add(LoadBookmarks(currentUser.uid));
          context.read<VehicleBloc>().add(LoadVehicles(currentUser.uid));
          context.read<NotificationBloc>().add(
            StartListeningNotificationsEvent(userId: currentUser.uid),
          );
        }
      },
      child: Container(
        color: AppColors.primary,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: RefreshIndicator(
              backgroundColor: Colors.white,
              onRefresh: _onRefresh,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  HomeAppBar(),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 15,
                        bottom: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SpecialOfferSection(),
                          SizedBox(height: 20),
                          ChooseCategorySection(),
                          SizedBox(height: 20),
                          PopularServiceProviderSection(),
                          SizedBox(height: 20),
                          RecentBookingsSection(),
                          SizedBox(height: 20),
                          MembershipBenefitsSection(),
                          SizedBox(height: 20),
                          ReferAndEarnSection(),
                          SizedBox(height: 20),
                          TopReviewsSection(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Animate BottomNavigationBar height smoothly
            bottomNavigationBar: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: _isNavBarVisible ? kBottomNavigationBarHeight : 0,
              // Animate height
              child: Wrap(
                children: [
                  Opacity(
                    opacity: _isNavBarVisible ? 1.0 : 0.0, // Fade effect
                    child: BottomNavigationBarSection(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showLocationDialog() async {
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Enable Location"),
            content: Text(
              "Location services are disabled. Please enable them.",
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await Geolocator.openLocationSettings();
                },
                child: Text("Open Settings"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
            ],
          ),
    );
  }

  Future<void> _showPermissionDialog() async {
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Permission Required"),
            content: Text(
              "Please allow location permission from app settings.",
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await Geolocator.openAppSettings();
                },
                child: Text("Open App Settings"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
            ],
          ),
    );
  }
}
