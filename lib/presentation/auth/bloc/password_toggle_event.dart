import 'package:equatable/equatable.dart';

abstract class PasswordToggleEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Event for toggling password visibility
class TogglePasswordVisibility extends PasswordToggleEvent {}
