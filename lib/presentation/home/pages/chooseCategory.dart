import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/category_entity.dart';
import '../../bookmark/widgets/serviceCard.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_state.dart';
import '../bloc/serviceProvider/service_provider_bloc.dart';
import '../bloc/serviceProvider/service_provider_state.dart';

class ChooseCategoryPage extends StatefulWidget {
  final String categoryId;

  const ChooseCategoryPage({super.key, required this.categoryId});

  @override
  State<ChooseCategoryPage> createState() => _ChooseCategoryPageState();
}

class _ChooseCategoryPageState extends State<ChooseCategoryPage> {
  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.categoryId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CategoryLoaded) {
                  return _buildCategoryTabs(state.categories);
                } else if (state is CategoryError) {
                  return Text(state.message);
                }
                return const SizedBox.shrink();
              },
            ),
            const Divider(color: AppColors.lightGray, thickness: 1, height: 25),
            Expanded(
              child: BlocBuilder<ServiceProviderBloc, ServiceProviderState>(
                builder: (context, state) {
                  if (state is ServiceProviderLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ServiceProviderLoaded) {
                    final filteredProviders =
                        state.serviceProviders
                            .where(
                              (provider) => provider.categoryIds.contains(
                                selectedCategory,
                              ),
                            )
                            .toList();

                    if (filteredProviders.isEmpty) {
                      return const Center(child: Text("No providers found."));
                    }

                    return ListView.builder(
                      clipBehavior: Clip.none,
                      itemCount: filteredProviders.length,
                      itemBuilder:
                          (context, index) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ServiceCard(
                              serviceProvider: filteredProviders[index],
                            ),
                          ),
                    );
                  } else if (state is ServiceProviderError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTabs(List<CategoryEntity> categories) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) => _categoryTab(category)).toList(),
      ),
    );
  }

  Widget _categoryTab(CategoryEntity category) {
    final isSelected = selectedCategory == category.id;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedCategory = category.id;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? AppColors.primary : AppColors.lightGray,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          category.name,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.darkGrey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => context.pop(),
      ),
      title: const Text(
        "Choose Category",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
    );
  }
}
