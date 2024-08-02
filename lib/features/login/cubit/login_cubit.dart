import 'package:api_client/api_client.dart';
import 'package:app_core/app_core.dart';
import 'package:user_repository/user_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const LoginState.initial());

  final UserRepository _userRepository;

  // retrieve code
  Future<void> signInWithPhone({
    required String phoneNumber,
    required void Function(PhoneAuthCredential) verificationCompleted,
    required void Function(FirebaseAuthException) verificationFailed,
    required void Function(String, int?) codeSent,
    required void Function(String) codeAutoRetrievalTimeout,
  }) async {
    try {
      emit(const LoginState.verifyingPhone());
      await _userRepository.verifyPhone(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: (String verificationId, int? forceResendingToken) {
          print('Code sent with verification ID: $verificationId');
          codeSent(verificationId, forceResendingToken);
        },
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } on PhoneNumberSignInFailure {
      emit(const LoginState.initial());
    } on UserFailure catch (failure) {
      _onLoginFailed(failure);
    }
  }

  // sign the user in
  Future<void> signInWithOTP(String otp, String? verificationId) async {
    try {
      emit(const LoginState.signingInWithPhone());
      await _userRepository.signInWithOTP(otp, verificationId);
    } on PhoneNumberSignInFailure {
      emit(const LoginState.initial());
    } on UserFailure catch (failure) {
      _onLoginFailed(failure);
    }
  }

  void _onLoginFailed(UserFailure failure) {
    emit(LoginState.failure(failure));
    emit(const LoginState.initial());
  }
}
