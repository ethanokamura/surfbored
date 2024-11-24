part of 'profile_cubit.dart';

class ProfileState {
  /// Private constructor for creating [ProfileState] instances.
  ProfileState({
    required this.user,
    this.isLoading = false,
    this.hasError = false,
  });
  factory ProfileState.loading() =>
      ProfileState(user: UserData.empty, isLoading: true);
  factory ProfileState.success(UserData userData) =>
      ProfileState(user: userData);
  factory ProfileState.failure() =>
      ProfileState(user: UserData.empty, hasError: true);
  final UserData user;
  final bool isLoading;
  final bool hasError;
}
