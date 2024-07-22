import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/core/services/auth_service.dart';
import 'package:rando/core/services/user_service.dart';
import 'profile_edit_event.dart';
import 'profile_edit_state.dart';

class ProfileEditBloc extends Bloc<ProfileEditEvent, ProfileEditState> {
  final UserService userService;
  final AuthService authService;

  ProfileEditBloc(this.userService, this.authService)
      : super(ProfileEditInitial()) {
    on<EditProfileField>(_onEditProfileField);
    on<UpdateProfileImage>(_onUpdateProfileImage);
  }

  Future<void> _onEditProfileField(
      EditProfileField event, Emitter<ProfileEditState> emit) async {
    emit(ProfileEditLoading());
    try {
      await userService.updateUserField(
          authService.user!.uid, event.field, event.value);
      emit(ProfileEditSuccess());
    } catch (e) {
      emit(ProfileEditError(e.toString()));
    }
  }

  Future<void> _onUpdateProfileImage(
      UpdateProfileImage event, Emitter<ProfileEditState> emit) async {
    emit(ProfileEditLoading());
    try {
      await userService.setPhotoURL(authService.user!.uid, event.imageUrl);
      emit(ProfileEditSuccess());
    } catch (e) {
      emit(ProfileEditError(e.toString()));
    }
  }
}
