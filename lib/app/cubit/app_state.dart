part of 'app_cubit.dart';

enum AppStatus {
  unauthenticated,
  newlyAuthenticated,
  needsUsername,
  authenticated,
  failure,
}

/// Auth Status Extenstions for public access to the current AppStatus
extension AppStatusExtensions on AppStatus {
  bool get isUnauthenticated => this == AppStatus.unauthenticated;
  bool get isNewlyAuthenticated => this == AppStatus.newlyAuthenticated;
  bool get needsUsername => this == AppStatus.needsUsername;
  bool get isAuthenticated => this == AppStatus.authenticated;
  bool get isFailure => this == AppStatus.failure;
}

/// Main app state definitions / construction
final class AppState extends Equatable {
  const AppState._({
    required this.status,
    this.user = UserData.empty,
    this.failure = UserFailure.empty,
  });

  const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  const AppState.newlyAuthenticated(UserData user)
      : this._(
          status: AppStatus.newlyAuthenticated,
          user: user,
        );

  const AppState.needsUsername(UserData user)
      : this._(
          status: AppStatus.needsUsername,
          user: user,
        );

  const AppState.authenticated(UserData user)
      : this._(
          status: AppStatus.authenticated,
          user: user,
        );

  const AppState.failure({
    required UserFailure failure,
    required UserData user,
  }) : this._(
          status: AppStatus.failure,
          user: user,
          failure: failure,
        );

  final AppStatus status;
  final UserData user;
  final UserFailure failure;

  @override
  List<Object?> get props => [status, user, failure];
}

/// App State Extenstions for public access to the current AppState
extension AppStateExtensions on AppState {
  bool get isUnauthenticated => status.isUnauthenticated;
  bool get isNewlyAuthenticated => status.isNewlyAuthenticated;
  bool get needsUsername => status.needsUsername;
  bool get isAuthenticated => status.isAuthenticated;
  bool get isFailure => status.isFailure;
}
