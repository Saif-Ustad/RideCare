import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridecare/presentation/explore/widgets/serviceProviderCard.dart';
import '../../bookmark/bloc/bookmark_bloc.dart';
import '../../bookmark/bloc/bookmark_event.dart';
import '../../bookmark/bloc/bookmark_state.dart';
import '../../home/bloc/serviceProvider/service_provider_bloc.dart';
import '../../home/bloc/serviceProvider/service_provider_state.dart';

class ServiceProviderList extends StatelessWidget {
  const ServiceProviderList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceProviderBloc, ServiceProviderState>(
      builder: (context, serviceProviderState) {
        if (serviceProviderState is ServiceProviderLoaded) {
          return BlocBuilder<BookmarkBloc, BookmarkState>(
            builder: (context, bookmarkState) {
              List<String> bookmarkedIds = [];
              final userId = FirebaseAuth.instance.currentUser?.uid;

              if (bookmarkState is BookmarkLoaded) {
                bookmarkedIds =
                    bookmarkState.bookmarkedServiceProviders.map((e) => e.id).toList();
              }

              return Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 70),
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    children:
                        serviceProviderState.serviceProviders.map((provider) {
                          final isBookmarked = bookmarkedIds.contains(
                            provider.id,
                          );
                          return ServiceProviderCard(
                            provider: provider,
                            isBookmarked: isBookmarked,
                            onBookmarkToggle: () {
                              if (userId != null) {
                                context.read<BookmarkBloc>().add(
                                  ToggleBookmarkedServiceProviders(
                                    userId,
                                    provider.id,
                                  ),
                                );
                              }
                            },
                          );
                        }).toList(),
                  ),
                ),
              );
            },
          );
        } else if (serviceProviderState is ServiceProviderLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (serviceProviderState is ServiceProviderError) {
          return Center(child: Text(serviceProviderState.message));
        } else {
          return const SizedBox(); // Fallback UI for unknown state
        }
      },
    );
  }
}
