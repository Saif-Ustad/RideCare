import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/widgets/bottomBar/bottomBar.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../home/bloc/user/user_bloc.dart';
import '../../home/bloc/user/user_event.dart';
import '../../home/bloc/user/user_state.dart';

class YourProfilePage extends StatefulWidget {
  const YourProfilePage({super.key});

  @override
  State<YourProfilePage> createState() => _YourProfilePageState();
}

class _YourProfilePageState extends State<YourProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? _selectedGender;
  String? _profileImageUrl;
  XFile? _pickedImage;

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // context.read<UserBloc>().add(LoadUserEvent());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _buildLeadingIconButton(() => context.go('/home')),
        title: const Text(
          "Profile",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            final user = state.user;
            // Initialize form fields once when user data is loaded.
            if (!_isInitialized) {
              _nameController.text = user.displayName ?? '';
              _phoneController.text = user.phoneNumber ?? '';
              _selectedGender = user.gender;
              _profileImageUrl = user.userProfileImageUrl;
              _isInitialized = true;
            }
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildProfileImage(),
                const SizedBox(height: 30),
                _buildProfileCard(
                  title: 'Name',
                  icon: Icons.person,
                  controller: _nameController,
                ),
                _buildProfileCard(
                  title: 'Phone Number',
                  icon: Icons.phone,
                  controller: _phoneController,
                ),
                _buildProfileCard(
                  title: 'Email',
                  icon: Icons.email,
                  hintText: user.email ?? '',
                  isEditable: false,
                ),
                _buildGenderDropdown(),
                const SizedBox(height: 30),
              ],
            );
          } else if (state is UserError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
      bottomNavigationBar: CustomBottomBar(
        text: "Save Changes",
        onPressed: _saveChanges,
      ),
    );
  }

  Widget _buildProfileCard({
    required String title,
    required IconData icon,
    TextEditingController? controller,
    String? hintText,
    bool isEditable = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 50,
            child: TextField(
              controller: controller,
              enabled: isEditable,
              decoration: InputDecoration(
                prefixIcon: Icon(icon, color: AppColors.darkGrey),
                hintText: hintText,
                filled: true,
                fillColor:
                    isEditable ? AppColors.lightGray : Colors.grey.shade200,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gender',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 50,
            child: DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.transgender,
                  color: AppColors.darkGrey,
                ),
                hintText: 'Select',
                filled: true,
                fillColor: AppColors.lightGray,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.black, fontSize: 14),
              dropdownColor: AppColors.lightGray,
              items:
                  ['Male', 'Female', 'Other']
                      .map(
                        (gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGender = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    ImageProvider? imageProvider;
    if (_pickedImage != null) {
      imageProvider = FileImage(File(_pickedImage!.path));
    } else if (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) {
      imageProvider = CachedNetworkImageProvider(_profileImageUrl!);
    }

    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: imageProvider,
            child:
                imageProvider == null
                    ? const Icon(Icons.person, size: 50, color: Colors.white)
                    : null,
          ),
          Positioned(
            bottom: 0,
            right: 4,
            child: InkWell(
              onTap: _pickImageFromGallery,
              child: _buildEditIcon(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditIcon(Color color) => Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      border: Border.all(width: 2, color: Colors.white),
      shape: BoxShape.circle,
      color: color,
    ),
    child: const Icon(Icons.edit, color: Colors.white, size: 16),
  );

  void _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = picked;
        _profileImageUrl = picked.path;
      });
    }
  }

  Future<void> _saveChanges() async {
    final bloc = context.read<UserBloc>();
    final currentState = bloc.state;

    if (currentState is UserLoaded) {
      final updatedUser = currentState.user.copyWith(
        displayName: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        gender: _selectedGender,
        userProfileImageUrl:
            _profileImageUrl ?? currentState.user.userProfileImageUrl,
      );

      bloc.add(UpdateUserProfileEvent(updatedUser: updatedUser));
    }
  }

  Widget _buildLeadingIconButton(VoidCallback onPressed) => Padding(
    padding: const EdgeInsets.only(left: 15),
    child: Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.darkGrey, width: 1),
        color: Colors.white,
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
        onPressed: onPressed,
        constraints: const BoxConstraints(),
        padding: EdgeInsets.zero,
      ),
    ),
  );
}
