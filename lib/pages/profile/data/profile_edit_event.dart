import 'package:equatable/equatable.dart';

abstract class ProfileEditEvent extends Equatable {
  const ProfileEditEvent();

  @override
  List<Object> get props => [];
}

class EditProfileField extends ProfileEditEvent {
  final String field;
  final String value;

  const EditProfileField(this.field, this.value);

  @override
  List<Object> get props => [field, value];
}

class UpdateProfileImage extends ProfileEditEvent {
  final String imageUrl;

  const UpdateProfileImage(this.imageUrl);

  @override
  List<Object> get props => [imageUrl];
}
