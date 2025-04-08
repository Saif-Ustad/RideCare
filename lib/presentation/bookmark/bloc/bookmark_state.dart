import 'package:equatable/equatable.dart';
import '../../../domain/entities/service_provider_entity.dart';

abstract class BookmarkState extends Equatable {
  const BookmarkState();

  @override
  List<Object?> get props => [];
}

class BookmarkInitial extends BookmarkState {}

class BookmarkLoading extends BookmarkState {}

class BookmarkLoaded extends BookmarkState {
  final List<ServiceProviderEntity> bookmarkedServices;
  const BookmarkLoaded(this.bookmarkedServices);

  @override
  List<Object?> get props => [bookmarkedServices];
}

class BookmarkError extends BookmarkState {
  final String message;
  const BookmarkError(this.message);

  @override
  List<Object?> get props => [message];
}
