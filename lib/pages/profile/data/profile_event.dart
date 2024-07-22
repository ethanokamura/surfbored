// profile_event.dart
abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {
  final String userId;

  LoadProfile(this.userId);
}

class UpdateProfileField extends ProfileEvent {
  final String field;
  final String value;

  UpdateProfileField(this.field, this.value);
}

class LogOut extends ProfileEvent {}
