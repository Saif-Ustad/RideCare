import 'package:equatable/equatable.dart';

abstract class BookmarkEvent extends Equatable {
  const BookmarkEvent();

  @override
  List<Object> get props => [];
}

class LoadBookmarks extends BookmarkEvent {
  final String userId;
  const LoadBookmarks(this.userId);

  @override
  List<Object> get props => [userId];
}

class ToggleBookmarkedServiceProviders extends BookmarkEvent {
  final String userId;
  final String serviceProviderId;

  const ToggleBookmarkedServiceProviders(this.userId, this.serviceProviderId);

  @override
  List<Object> get props => [userId, serviceProviderId];
}
