import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ridecare/core/configs/theme/app_colors.dart';
import 'package:ridecare/domain/entities/service_provider_entity.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutTab extends StatefulWidget {
  final String aboutText;
  final String userName;
  final String userRole;
  final String userImage;
  final double rating;
  final String experience;
  final LocationEntity location;
  final AvailabilityEntity availability;
  final String phoneNumber;

  const AboutTab({
    super.key,
    required this.aboutText,
    required this.userName,
    required this.userRole,
    required this.userImage,
    required this.rating,
    required this.experience,
    required this.location,
    required this.availability,
    required this.phoneNumber,
  });

  @override
  State<AboutTab> createState() => _AboutTabState();
}

class _AboutTabState extends State<AboutTab> {
  bool isExpanded = false;


  Future<void> _launchPhoneDialer(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
    } else {
      print("Could not launch $phoneUri");
    }
  }

  Future<void> _launchWhatsApp(String phoneNumber) async {
    final sanitizedNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    final Uri whatsappUri = Uri.parse("https://wa.me/$sanitizedNumber");
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      print("Could not launch $whatsappUri");
    }
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 10),

          RichText(
            text: TextSpan(
              text:
                  isExpanded
                      ? widget.aboutText
                      : '${widget.aboutText.substring(0, 100)}...',
              style: const TextStyle(
                color: AppColors.darkGrey,
                fontSize: 14,
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text: isExpanded ? ' Read Less' : ' Read More',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(widget.userImage),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                    Text(
                      widget.userRole,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.darkGrey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    _buildStarRating(widget.rating),
                  ],
                ),
              ),
              Row(
                children: [
                  _iconButton(Icons.phone, () => _launchPhoneDialer(widget.phoneNumber)),
                  const SizedBox(width: 10),
                  _iconButton(Icons.chat, () => _launchWhatsApp(widget.phoneNumber)),
                ],
              )
            ],
          ),
          const SizedBox(height: 25),

          // Additional Details
          _infoRow(Icons.work, "Experience: ${widget.experience} Years"),
          _infoRow(Icons.location_on, "Location: ${widget.location.address}"),
          _infoRow(
            Icons.schedule,
            "Availability: ${widget.availability.from} - ${widget.availability.to}",
          ),

          const SizedBox(height: 20),

          Center(
            child: GestureDetector(
              onTap: () {
                // Follow action here
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(width: 2, color: AppColors.primary),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.person_add_alt_1,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Follow",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.15),
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.darkGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    return Row(
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return Icon(Icons.star, size: 16, color: Colors.amber);
        } else if (index < rating && rating - index >= 0.5) {
          return Icon(Icons.star_half, size: 16, color: Colors.amber);
        } else {
          return Icon(Icons.star_border, size: 16, color: Colors.amber);
        }
      }),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 1.5),
        ),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
    );
  }
}
