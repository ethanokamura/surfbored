part of 'authentication_cubit.dart';

enum AuthStatus { initial, verifying, signingIn, failure, success }

extension LoginStatusExtensions on AuthStatus {
  bool get isSigningIn => this == AuthStatus.signingIn;
  bool get isVerifying => this == AuthStatus.verifying;
}

enum SignInMethod { none, phone }

extension SignInMethodExtensions on SignInMethod {
  bool get isPhone => this == SignInMethod.phone;
}

final class AuthState extends Equatable {
  const AuthState._({
    this.status = AuthStatus.initial,
    this.signInMethod = SignInMethod.none,
    this.failure = UserFailure.empty,
  });

  const AuthState.initial() : this._();

  const AuthState.verifyingPhone()
      : this._(
          status: AuthStatus.verifying,
          signInMethod: SignInMethod.phone,
        );

  const AuthState.signingInWithPhone()
      : this._(
          status: AuthStatus.signingIn,
          signInMethod: SignInMethod.phone,
        );

  const AuthState.successfulSignIn()
      : this._(
          status: AuthStatus.success,
        );

  const AuthState.failure(UserFailure failure)
      : this._(
          status: AuthStatus.failure,
          failure: failure,
        );

  final AuthStatus status;
  final SignInMethod signInMethod;
  final UserFailure failure;

  @override
  List<Object> get props => [status, signInMethod, failure];
}

extension LoginStateExtensions on AuthState {
  bool get isFailure => status == AuthStatus.failure;
  bool get isSuccess => status == AuthStatus.success;
  bool get isSigningInWithPhone => status.isSigningIn && signInMethod.isPhone;
  bool get isVerifyingWithOTP => status.isVerifying && signInMethod.isPhone;
}
