import 'package:equatable/equatable.dart';

import '../../../../domain/entities/user_entity.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserEvent extends UserEvent {}

class UpdateUserProfileEvent extends UserEvent {
  final UserEntity updatedUser;

  const UpdateUserProfileEvent({required this.updatedUser});

  @override
  List<Object?> get props => [updatedUser];
}
