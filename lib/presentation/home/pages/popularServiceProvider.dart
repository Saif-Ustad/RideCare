import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ridecare/presentation/home/bloc/serviceProvider/service_provider_bloc.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../bookmark/widgets/serviceCard.dart';
import '../bloc/serviceProvider/service_provider_state.dart';

class PopularServiceProviderPage extends StatefulWidget {
  const PopularServiceProviderPage({super.key});

  @override
  State<PopularServiceProviderPage> createState() => _PopularServiceProviderPageState();
}
class _PopularServiceProviderPageState extends State<PopularServiceProviderPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceProviderBloc, ServiceProviderState>(
      builder: (context, state) {
        final allProviders = state is ServiceProviderLoaded ? state.serviceProviders : [];

        final filteredProviders = allProviders
            .where((provider) =>
            provider.name.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: _buildLeadingIconButton(() {
              if (_isSearching) {
                setState(() {
                  _isSearching = false;
                  _searchQuery = '';
                  _searchController.clear();
                });
              } else {
                context.pop();
              }
            }),
            title: _isSearching
                ? _buildSearchBar()
                : const Text(
              "Service Providers",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            actions: [
              if (!_isSearching)
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: state is ServiceProviderLoading
                ? const Center(child: CircularProgressIndicator())
                : (filteredProviders.isEmpty
                ? const Center(child: Text('No Service Provider found.'))
                : ListView.builder(
              clipBehavior: Clip.none,
              itemCount: filteredProviders.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ServiceCard(serviceProvider: filteredProviders[index]),
              ),
            )),
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
        hintText: 'Search...',
        filled: true,
        fillColor: AppColors.lightGray,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
          icon: const Icon(Icons.clear, size: 20),
          onPressed: () {
            _searchController.clear();
            setState(() => _searchQuery = '');
          },
        )
            : const Icon(Icons.search, size: 20),
      ),
      style: const TextStyle(fontSize: 14),
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
        icon: Icon(
          _isSearching ? Icons.close : Icons.arrow_back,
          color: Colors.black,
          size: 20,
        ),
        onPressed: onPressed,
        constraints: const BoxConstraints(),
        padding: EdgeInsets.zero,
      ),
    ),
  );
}

