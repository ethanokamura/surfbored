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
          verificationFailed(e);
          emit(const AuthState.initial());
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          codeSent(verificationId, forceResendingToken);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          codeAutoRetrievalTimeout(verificationId);
        },
      );
    } on PhoneNumberSignInFailure {
      emit(const AuthState.initial());
    } on UserFailure catch (failure) {
      _onLoginFailed(failure);
    }
  }

  // sign the user in
  Future<void> signInWithOTP(String otp, String? verificationId) async {
    try {
      emit(const AuthState.signingInWithPhone());
      await _userRepository.signInWithOTP(otp, verificationId);
      emit(const AuthState.successfulSignIn());
    } on PhoneNumberSignInFailure {
      emit(const AuthState.initial());
    } on UserFailure catch (failure) {
      _onLoginFailed(failure);
    }
  }

  void _onLoginFailed(UserFailure failure) {
    emit(AuthState.failure(failure));
    emit(const AuthState.initial());
  }
}
