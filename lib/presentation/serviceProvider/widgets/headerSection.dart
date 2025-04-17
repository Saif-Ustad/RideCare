import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ridecare/domain/entities/service_provider_entity.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../bookmark/bloc/bookmark_bloc.dart';
import '../../bookmark/bloc/bookmark_event.dart';
import '../../bookmark/bloc/bookmark_state.dart';

class HeaderSection extends StatelessWidget {
  final List<String> images;
  final ServiceProviderEntity provider;

  const HeaderSection({
    super.key,
    required this.images,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarkBloc, BookmarkState>(
      builder: (context, bookmarkState) {
        List<String> bookmarkedIds = [];
        final userId = FirebaseAuth.instance.currentUser?.uid;

        if (bookmarkState is BookmarkLoaded) {
          bookmarkedIds =
              bookmarkState.bookmarkedServiceProviders
                  .map((e) => e.id)
                  .toList();
        }
        final isBookmarked = bookmarkedIds.contains(provider.id);

        return Stack(
          children: [
            CachedNetworkImage(
              imageUrl: provider.workImageUrl,
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder:
                  (context, url) => Container(
                    height: 100,
                    width: double.infinity,
                    color: Colors.grey[300],
                  ),
              errorWidget:
                  (context, url, error) => Container(
                    height: 100,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, color: Colors.red),
                  ),
              fadeInDuration: const Duration(milliseconds: 500),
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
                  _iconButton(Icons.share, () async {
                    final shareUrl =
                        'https://your-app-link.com/provider/${provider.id}';
                    await Share.share(
                      'Check out this amazing service provider on RideCare! 🚗\n\n$shareUrl',
                    );
                  }),

                  const SizedBox(width: 10),
                  _iconButton(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    () {
                      if (userId != null) {
                        context.read<BookmarkBloc>().add(
                          ToggleBookmarkedServiceProviders(
                            userId: userId,
                            serviceProvider: provider,
                          ),
                        );
                      }
                    },
                  ),
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
      },
    );
  }

  Widget _buildGalleryThumbnails() {
    int visibleImageCount = images.length > 5 ? 5 : images.length;
    double imageWidth = 50;
    double padding = 4;
    double totalWidth = (imageWidth + padding) * visibleImageCount;

    return Container(
      height: 50,
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(visibleImageCount, (index) {
              bool isLastImage = index == 4 && images.length > 5;
              return Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: images[index],
                        width: 55,
                        height: 55,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => Container(
                              width: 55,
                              height: 55,
                              color: Colors.grey[300],
                            ),
                        errorWidget:
                            (context, url, error) => const Icon(Icons.error),
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
            }),
          ),
        ),
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
