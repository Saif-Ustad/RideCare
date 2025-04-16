import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridecare/domain/usecases/user/get_current_user_usecase.dart';
import '../../../../domain/usecases/user/update_user_profile_usecase.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final UpdateUserProfileUseCase updateUserProfile;

  UserBloc({
    required this.getCurrentUserUseCase,
    required this.updateUserProfile,
  }) : super(UserInitial()) {
    on<LoadUserEvent>(_onLoadUser);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
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

  Future<void> _onUpdateUserProfile(
    UpdateUserProfileEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      await updateUserProfile(event.updatedUser);
      final updatedUser = await getCurrentUserUseCase.call();
      emit(UserLoaded(updatedUser));
    } catch (e) {
      emit(UserError("Failed to update user: ${e.toString()}"));
    }
  }
}
