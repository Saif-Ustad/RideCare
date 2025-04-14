import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridecare/domain/usecases/user/get_current_user_usecase.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;

  UserBloc({required this.getCurrentUserUseCase}) : super(UserInitial()) {
    on<LoadUserEvent>(_onLoadUser);
  }

  Future<void> _onLoadUser(LoadUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final user = await getCurrentUserUseCase.call();
      print("user loaded : ${user.uid}");
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError("Failed to load user: ${e.toString()}"));
    }
  }
}
