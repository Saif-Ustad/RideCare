import 'package:equatable/equatable.dart';

class PasswordToggleState extends Equatable {
  final bool isPasswordVisible;

  const PasswordToggleState({this.isPasswordVisible = false});

  PasswordToggleState copyWith({bool? isPasswordVisible}) {
    return PasswordToggleState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }

  @override
  List<Object?> get props => [isPasswordVisible];
}
