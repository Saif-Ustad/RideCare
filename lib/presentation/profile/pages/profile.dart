import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../common/widgets/bottomNavigationBar/bottomNavigationBar.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/user_entity.dart';
import '../../home/bloc/user/user_bloc.dart';
import '../../home/bloc/user/user_event.dart';
import '../../home/bloc/user/user_state.dart';
import '../widgets/profileEditSection.dart';
import '../widgets/profileMenuList.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(LoadUserEvent());
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
      body: Stack(
        children: [
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is UserLoaded) {
                UserEntity user = state.user;

                return Column(
                  children: [
                    SizedBox(height: 10),
                    ProfileSection(user: user),
                    SizedBox(height: 10),
                    Expanded(child: ProfileMenuList()),
                    SizedBox(height: 60),
                  ],
                );
              } else if (state is UserError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox.shrink();
            },
          ),
          const BottomNavigationBarSection(),
        ],
      ),
    );
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
        icon: Icon(Icons.arrow_back, color: Colors.black, size: 20),
        onPressed: onPressed,
        constraints: const BoxConstraints(),
        padding: EdgeInsets.zero,
      ),
    ),
  );
}
