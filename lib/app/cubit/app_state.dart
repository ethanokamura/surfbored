part of 'app_cubit.dart';

enum AppStatus {
  unauthenticated,
  newlyAuthenticated,
  authenticated,
  failure,
  // main
  home,
  search,
  inbox,
  create,
  profile,
}

extension AppStatusExtensions on AppStatus {
  bool get isUnauthenticated => this == AppStatus.unauthenticated;
  bool get isNewlyAuthenticated => this == AppStatus.newlyAuthenticated;
  bool get isAuthenticated => this == AppStatus.authenticated;
  bool get isFailure => this == AppStatus.failure;
}

final class AppState extends Equatable {
  const AppState._({
    required this.status,
    this.user = User.empty,
    this.failure = UserFailure.empty,
    this.parameters = const {},
  });

  const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  const AppState.newlyAuthenticated(User user)
      : this._(
          status: AppStatus.newlyAuthenticated,
          user: user,
        );

  const AppState.authenticated(User user)
      : this._(
          status: AppStatus.authenticated,
          user: user,
        );

  const AppState.failure({
    required UserFailure failure,
    required User user,
  }) : this._(
          status: AppStatus.failure,
          user: user,
          failure: failure,
        );

  final AppStatus status;
  final User user;
  final UserFailure failure;
  final Map<String, dynamic> parameters;

  @override
  List<Object?> get props => [status, user, failure, parameters];
}

extension AppStateExtensions on AppState {
  bool get isUnauthenticated => status.isUnauthenticated;
  bool get isNewlyAuthenticated => status.isNewlyAuthenticated;
  bool get isAuthenticated => status.isAuthenticated;
  bool get isFailure => status.isFailure;

  AppState copyWith({
    AppStatus? status,
    User? user,
    UserFailure? failure,
    Map<String, dynamic>? parameters,
  }) {
    return AppState._(
      status: status ?? this.status,
      user: user ?? this.user,
      failure: failure ?? this.failure,
      parameters: parameters ?? this.parameters,
    );
  }
}
