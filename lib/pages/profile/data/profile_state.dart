import 'package:equatable/equatable.dart';
import 'package:rando/core/models/models.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserData userData;
  final bool isCurrentUser;

  const ProfileLoaded(this.userData, this.isCurrentUser);

  @override
  List<Object> get props => [userData, isCurrentUser];
}

class ProfileError extends ProfileState {
  final String error;

  const ProfileError(this.error);

  @override
  List<Object> get props => [error];
}

class ProfileEditing extends ProfileState {}

class ProfileEdited extends ProfileState {}
