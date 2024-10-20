part of 'authentication_cubit.dart';

/// Defines possible status for authentication process.
enum AuthStatus {
  initial,
  loading,
  failure,
  loaded,
  otp,
}

/// Constructs the AuthState and related methods
final class AuthState extends Equatable {
  const AuthState._({
    this.phoneNumber = '',
    this.status = AuthStatus.initial,
    this.failure = UserFailure.empty,
  });

  const AuthState.initial() : this._();

  final String phoneNumber;
  final AuthStatus status;
  final UserFailure failure;

  @override
  List<Object?> get props => [
        phoneNumber,
        status,
        failure,
      ];

  /// Allows for easy state manipulation
  AuthState copyWith({
    String? phoneNumber,
    AuthStatus? status,
    UserFailure? failure,
  }) {
    return AuthState._(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}

/// Public getters for AuthStatus
extension AuthStateExtensions on AuthState {
  bool get isFailure => status == AuthStatus.failure;
  bool get isSuccess => status == AuthStatus.loaded;
  bool get isLoading => status == AuthStatus.loading;
  bool get needsOtp => status == AuthStatus.otp;
}

/// Private setters for AuthStatus
extension _AuthStateExtensions on AuthState {
  AuthState fromLoading() => copyWith(
        status: AuthStatus.loading,
      );
  AuthState fromLoaded() => copyWith(
        status: AuthStatus.loaded,
      );
  AuthState fromFailure(UserFailure failure) => copyWith(
        status: AuthStatus.failure,
        failure: failure,
      );
  AuthState fromNeedsOTP(String phoneNumber) => copyWith(
        phoneNumber: phoneNumber,
        status: AuthStatus.otp,
      );
}
