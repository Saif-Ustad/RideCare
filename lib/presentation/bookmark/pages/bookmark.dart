import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ridecare/domain/entities/service_provider_entity.dart';
import '../../../common/widgets/bottomNavigationBar/bottomNavigationBar.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../bloc/bookmark_bloc.dart';
import '../bloc/bookmark_event.dart';
import '../bloc/bookmark_state.dart';
import '../widgets/serviceCard.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isNavBarVisible = true;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isNavBarVisible) setState(() => _isNavBarVisible = false);
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_isNavBarVisible) setState(() => _isNavBarVisible = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarkBloc, BookmarkState>(
      builder: (context, state) {
        final allBookmarks =
            state is BookmarkLoaded ? state.bookmarkedServiceProviders : [];
        final filteredBookmarks =
            allBookmarks
                .where(
                  (provider) => provider.name.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ),
                )
                .toList();

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: buildLeadingIconButton(() => context.go('/home')),
            title:
                _isSearching
                    ? _buildSearchBar()
                    : const Text(
                      "Bookmark",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
            centerTitle: true,
            actions: [
              !_isSearching
                  ? buildActionIconButton(() {
                    setState(() {
                      _isSearching = true;
                    });
                  })
                  : IconButton(
                    icon: const Icon(Icons.clear, color: Colors.black),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                        _isSearching = false;
                      });
                    },
                  ),
            ],
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child:
                    state is BookmarkLoaded
                        ? (filteredBookmarks.isEmpty
                            ? const Center(child: Text('No bookmarks found.'))
                            : ListView.builder(
                              controller: _scrollController,
                              clipBehavior: Clip.none,
                              itemCount: filteredBookmarks.length,
                              itemBuilder:
                                  (context, index) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: ServiceCard(
                                      serviceProvider: filteredBookmarks[index],
                                      onRemove:
                                          () => _showRemoveBottomSheet(
                                            filteredBookmarks[index],
                                          ),
                                    ),
                                  ),
                            ))
                        : state is BookmarkLoading
                        ? const Center(child: CircularProgressIndicator())
                        : const Center(child: Text('Something went wrong.')),
              ),
            ],
          ),
          bottomNavigationBar: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isNavBarVisible ? kBottomNavigationBarHeight : 0,
            child: Wrap(
              children: [
                Opacity(
                  opacity: _isNavBarVisible ? 1.0 : 0.0,
                  child: const BottomNavigationBarSection(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Search bookmarks...',
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        filled: true,
        fillColor: AppColors.lightGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(fontSize: 14),
    );
  }

  Widget buildLeadingIconButton(VoidCallback onPressed) => Padding(
    padding: const EdgeInsets.only(left: 15),
    child: circleIconButton(Icons.arrow_back, onPressed),
  );

  Widget buildActionIconButton(VoidCallback onPressed) => Padding(
    padding: const EdgeInsets.only(right: 15),
    child: circleIconButton(Icons.search, onPressed),
  );

  Widget circleIconButton(IconData icon, VoidCallback onPressed) => Container(
    height: 40,
    width: 40,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: AppColors.darkGrey, width: 1),
      color: Colors.white,
    ),
    child: IconButton(
      icon: Icon(icon, color: Colors.black, size: 20),
      onPressed: onPressed,
      constraints: const BoxConstraints(),
      padding: EdgeInsets.zero,
    ),
  );

  void _showRemoveBottomSheet(ServiceProviderEntity serviceProvider) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Remove from Bookmark?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const Divider(height: 20, color: AppColors.lightGray),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: serviceProvider.workImageUrl,
                            height: 100,
                            width: 130,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => Container(
                                  height: 100,
                                  width: 130,
                                  color: Colors.grey[300],
                                ),
                            errorWidget:
                                (context, url, error) => Container(
                                  height: 100,
                                  width: 130,
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.broken_image,
                                    color: Colors.red,
                                  ),
                                ),
                            fadeInDuration: const Duration(milliseconds: 500),
                          ),
                        ),

                        Positioned(
                          left: 6,
                          top: 6,
                          child: buildRatingBadge(serviceProvider.rating),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            serviceProvider.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              buildInfoRow(Icons.location_on, serviceProvider.distanceText ??  "- Km"),
                              const SizedBox(width: 12),
                              buildInfoRow(Icons.access_time_filled, serviceProvider.durationText ?? "- Min"),
                            ],
                          ),

                          const SizedBox(height: 5),
                          buildPriceText(
                            "${serviceProvider.serviceCharges.min} - ${serviceProvider.serviceCharges.max}",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        foregroundColor: AppColors.primary,
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final userId = FirebaseAuth.instance.currentUser?.uid;
                        if (userId != null) {
                          context.read<BookmarkBloc>().add(
                            ToggleBookmarkedServiceProviders(
                              userId: userId,
                              serviceProvider: serviceProvider,
                            ),
                          );
                        }
                        context.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Yes, Remove'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildRatingBadge(double rating) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Row(
      children: [
        Icon(Icons.star, color: Colors.amber, size: 16),
        const SizedBox(width: 4),
        Text(
          rating.toString(),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );

  Widget buildInfoRow(IconData icon, String text) => Padding(
    padding: const EdgeInsets.only(top: 4),
    child: Row(
      children: [
        Icon(icon, color: AppColors.primary.withOpacity(0.8), size: 12),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: AppColors.darkGrey, fontSize: 12)),
      ],
    ),
  );

  Widget buildPriceText(String priceRange) => Wrap(
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      const Text(
        "Rs. ",
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      Text(
        priceRange,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      const Text(
        " / Service",
        style: TextStyle(
          color: AppColors.darkGrey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    ],
  );
}
