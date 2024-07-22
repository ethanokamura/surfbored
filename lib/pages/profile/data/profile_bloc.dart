import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/core/services/auth_service.dart';
import 'package:rando/core/services/user_service.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserService userService;
  final AuthService authService;

  ProfileBloc(this.userService, this.authService) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfileField>(_onUpdateProfileField);
    on<LogOut>(_onLogOut);

    // Check if a user is already logged in and trigger LoadProfile event if so
    final currentUser = authService.user;
    if (currentUser != null) {
      add(LoadProfile(currentUser.uid));
    }
  }

  Future<void> _onLoadProfile(
      LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final userData = await userService.getUserData(event.userId);
      final isCurrentUser = event.userId == authService.user!.uid;
      emit(ProfileLoaded(userData, isCurrentUser));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfileField(
      UpdateProfileField event, Emitter<ProfileState> emit) async {
    try {
      await userService.updateUserField(
        authService.user!.uid,
        event.field,
        event.value,
      );
      // Refresh the profile after update
      final updatedUserData =
          await userService.getUserData(authService.user!.uid);
      emit(ProfileLoaded(updatedUserData, true));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onLogOut(LogOut event, Emitter<ProfileState> emit) async {
    await authService.signOut();
    // Handle navigation to login page
  }
}
