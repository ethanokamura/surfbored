import 'package:app_core/app_core.dart';
import 'package:user_repository/user_repository.dart';

part 'authentication_state.dart';

/// Allows the user to interact authentication servcies.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const AuthState.initial());

  final UserRepository _userRepository;

  /// Starts authentication process.
  /// If phone number is valid, it returns an OTP code.
  Future<void> signInWithPhone(String phoneNumber) async {
    try {
      emit(state.fromLoading());
      await _userRepository.sendOTP(phoneNumber: phoneNumber);
      emit(state.fromNeedsOTP(phoneNumber));
    } on PhoneNumberSignInFailure catch (failure) {
      _onLoginFailed(failure);
    } on UserFailure catch (failure) {
      _onLoginFailed(failure);
    }
  }

  /// Verifies OTP token.
  /// If the token is valid, the authentication process ends.
  Future<void> signInWithOTP(String otp) async {
    try {
      emit(state.fromLoading());
      await _userRepository.verifyOTP(phoneNumber: state.phoneNumber, otp: otp);
      emit(state.fromLoaded());
    } on PhoneNumberSignInFailure catch (failure) {
      _onLoginFailed(failure);
    } on UserFailure catch (failure) {
      _onLoginFailed(failure);
    }
  }

  /// Handles failure
  void _onLoginFailed(UserFailure failure) {
    emit(state.fromFailure(failure));
  }
}
