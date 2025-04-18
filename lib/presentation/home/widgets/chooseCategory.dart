import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/category_entity.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_state.dart';

class ChooseCategorySection extends StatelessWidget {
  const ChooseCategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Column(
        children: [
          _buildSectionHeader(context, "Choose Services"),
          SizedBox(height: 10),
          BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state is CategoryLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CategoryLoaded) {
                return _buildCategoryCards(context, state.categories);
              } else if (state is CategoryError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        GestureDetector(
          onTap: () {
            context.push('/choose-category');
          },
          child: Text(
            "See All",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCards(
    BuildContext context,
    List<CategoryEntity> categories,
  ) {
    // Limit the categories to only 3 if there are more
    final limitedCategories = categories.take(3).toList();

    return Row(
      children: [
        // Big Left Card
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              context.push(
                '/choose-category?category=${limitedCategories[2].id}',
              );
            },
            child: _buildBigServiceCard(
              title: limitedCategories[2].name,
              subtitle: "Temper erat elit elbum",
              // Can be customized per category
              icon: Icons.calendar_today,
            ),
          ),
        ),
        SizedBox(width: 10),

        // Right side smaller cards
        Expanded(
          flex: 1,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  context.push(
                    '/choose-category?category=${limitedCategories[0].id}',
                  );
                },
                child: _buildSmallServiceCard(
                  title: limitedCategories[0].name,
                  subtitle: "Temper erat elit",
                  // Can be customized per category
                  icon: Icons.build,
                ),
              ),
              const SizedBox(height: 10),

              GestureDetector(
                onTap: () {
                  context.push(
                    '/choose-category?category=${limitedCategories[1].id}',
                  );
                },
                child: _buildSmallServiceCard(
                  title: limitedCategories[1].name,
                  subtitle: "Temper erat elit",
                  // Can be customized per category
                  icon: Icons.directions_car,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBigServiceCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      height: 140,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 20,
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
            softWrap: true,
          ),
          SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 10, color: AppColors.darkGrey),
            softWrap: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSmallServiceCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 18,
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                  overflow: TextOverflow.visible,
                  softWrap: true,
                ),
                SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 10, color: AppColors.darkGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
