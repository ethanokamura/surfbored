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
    } on PhoneNumberSignInFailure {
      emit(const AuthState.initial());
    } on UserFailure catch (failure) {
      _onLoginFailed(failure);
    }
  }

  // sign the user in
  Future<void> signInWithOTP(String otp) async {
    try {
      emit(state.fromLoading());
      await _userRepository.verifyOTP(state.phoneNumber, otp);
      emit(state.fromSuccess());
    } on PhoneNumberSignInFailure {
      emit(const AuthState.initial());
    } on UserFailure catch (failure) {
      _onLoginFailed(failure);
    }
  }

  void _onLoginFailed(UserFailure failure) {
    emit(state.fromFailure(failure));
    emit(const AuthState.initial());
  }
}
