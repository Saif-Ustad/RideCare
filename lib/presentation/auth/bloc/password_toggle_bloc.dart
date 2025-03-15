import 'package:flutter_bloc/flutter_bloc.dart';

import 'password_toggle_event.dart';
import 'password_toggle_state.dart';


class PasswordToggleBloc extends Bloc<PasswordToggleEvent, PasswordToggleState> {
  PasswordToggleBloc() : super(const PasswordToggleState()) {
    on<TogglePasswordVisibility>((event, emit) {
      emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
    });
  }
}
