import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ridecare/core/configs/theme/app_colors.dart';

class GalleryTab extends StatefulWidget {
  final List<String> galleryImages;

  const GalleryTab({super.key, required this.galleryImages});

  @override
  State<GalleryTab> createState() => _GalleryTabState();
}

class _GalleryTabState extends State<GalleryTab> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    int imageCount =
        _showAll
            ? widget.galleryImages.length
            : (widget.galleryImages.length >= 4
                ? 4
                : widget.galleryImages.length);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gallery Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: "Gallery ",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "(${widget.galleryImages.length})",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showAll = !_showAll;
                  });
                },
                child: Text(
                  _showAll ? "Show Less" : "View All",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // GridView for Gallery Images
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: imageCount,
              itemBuilder: (context, index) {
                bool isLastVisible =
                    !_showAll &&
                    index == imageCount - 1 &&
                    widget.galleryImages.length > 4;

                return Stack(
                  children: [
                    _galleryItem(widget.galleryImages[index]),
                    if (isLastVisible)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "+${widget.galleryImages.length - 4} more",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget for Each Gallery Item
  Widget _galleryItem(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(color: Colors.grey[300]),
        errorWidget:
            (context, url, error) =>
                const Icon(Icons.broken_image, color: Colors.grey),
      ),
    );
  }
}
