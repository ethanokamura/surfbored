part of 'authentication_cubit.dart';

enum AuthStatus {
  initial,
  loading,
  failure,
  success,
  otp,
}

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

extension AuthStateExtensions on AuthState {
  bool get isFailure => status == AuthStatus.failure;
  bool get isSuccess => status == AuthStatus.success;
  bool get isLoading => status == AuthStatus.loading;
  bool get needsOtp => status == AuthStatus.otp;
}

extension _AuthStateExtensions on AuthState {
  AuthState fromLoading() => copyWith(
        status: AuthStatus.loading,
      );
  AuthState fromSuccess() => copyWith(
        status: AuthStatus.success,
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
