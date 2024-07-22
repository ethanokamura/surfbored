import 'package:equatable/equatable.dart';

abstract class ProfileEditState extends Equatable {
  const ProfileEditState();

  @override
  List<Object> get props => [];
}

class ProfileEditInitial extends ProfileEditState {}

class ProfileEditLoading extends ProfileEditState {}

class ProfileEditSuccess extends ProfileEditState {}

class ProfileEditError extends ProfileEditState {
  final String error;

  const ProfileEditError(this.error);

  @override
  List<Object> get props => [error];
}
