import 'package:api_client/api_client.dart';
import 'package:app_core/app_core.dart';
import 'package:user_repository/user_repository.dart';

part 'authentication_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const AuthState.initial());

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
      emit(const AuthState.verifyingPhone());
      await _userRepository.verifyPhone(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: (FirebaseAuthException e) {
          print('Verification failed: ${e.message}');
          verificationFailed(e);
          emit(const AuthState.initial());
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          print('Code sent with verification ID: $verificationId');
          codeSent(verificationId, forceResendingToken);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('Auto retrieval timeout: $verificationId');
          codeAutoRetrievalTimeout(verificationId);
        },
      );
    } on InvalidPhoneNumberFailure {
      print('invalid phone number');
    } on PhoneNumberSignInFailure catch (e) {
      print('Phone number sign-in failure: $e');
      emit(const AuthState.initial());
    } on UserFailure catch (failure) {
      _onLoginFailed(failure);
    }
  }

  // sign the user in
  Future<void> signInWithOTP(String otp, String? verificationId) async {
    try {
      emit(const AuthState.signingInWithPhone());
      print('signing in');
      await _userRepository.signInWithOTP(otp, verificationId);
      print('sign in success');
      emit(const AuthState.successfulSignIn());
    } on PhoneNumberSignInFailure catch (e) {
      print('Phone number sign-in failure: $e');
      emit(const AuthState.initial());
    } on UserFailure catch (failure) {
      print('user failure $failure');
      _onLoginFailed(failure);
    }
  }

  // send code
  Future<void> sendCode(String phoneNumber) async {
    await _userRepository.sendOTP(phoneNumber: phoneNumber);
  }

  // verify
  Future<void> verify(ConfirmationResult confirmationResult, String otp) async {
    await _userRepository.authenticateNewUser(
      confirmationResult: confirmationResult,
      otp: otp,
    );
  }

  void _onLoginFailed(UserFailure failure) {
    print('Login failed: $failure');
    emit(AuthState.failure(failure));
    emit(const AuthState.initial());
  }
}
