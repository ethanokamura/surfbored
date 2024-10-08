import 'package:app_core/app_core.dart';
import 'package:user_repository/user_repository.dart';

part 'authentication_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const AuthState.initial());

  final UserRepository _userRepository;

  // retrieve code
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

  // sign the user in
  Future<void> signInWithOTP(String otp) async {
    try {
      emit(state.fromLoading());
      await _userRepository.verifyOTP(phoneNumber: state.phoneNumber, otp: otp);
      emit(state.fromSuccess());
    } on PhoneNumberSignInFailure catch (failure) {
      _onLoginFailed(failure);
    } on UserFailure catch (failure) {
      _onLoginFailed(failure);
    }
  }

  void _onLoginFailed(UserFailure failure) {
    print('Login failed with: $failure');
    emit(state.fromFailure(failure));
  }
}
