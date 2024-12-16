import 'package:app_core/app_core.dart';

class UserFailure extends Failure {
  const UserFailure._();

  // user data retrieval
  factory UserFailure.fromCreate() => const CreateFailure();
  factory UserFailure.fromGet() => const GetFailure();
  factory UserFailure.fromStream() => const StreamFailure();
  factory UserFailure.fromUpdate() => const UpdateFailure();
  factory UserFailure.fromDelete() => const DeleteFailure();

  // auth
  factory UserFailure.fromAuthChanges() => const AuthChangesFailure();
  factory UserFailure.fromSignOut() => const SignOutFailure();
  factory UserFailure.fromInvalidPhoneNumber() =>
      const InvalidPhoneNumberFailure();
  factory UserFailure.fromPhoneNumberSignIn() =>
      const PhoneNumberSignInFailure();

  static const empty = EmptyFailure();
}

class EmptyFailure extends UserFailure {
  const EmptyFailure() : super._();
}

class InvalidPhoneNumberFailure extends UserFailure {
  const InvalidPhoneNumberFailure() : super._();
}

class AuthChangesFailure extends UserFailure {
  const AuthChangesFailure() : super._();

  @override
  bool get needsReauthentication => true;
}

class PhoneNumberSignInFailure extends UserFailure {
  const PhoneNumberSignInFailure() : super._();
}

class SignOutFailure extends UserFailure {
  const SignOutFailure() : super._();
}

class CreateFailure extends UserFailure {
  const CreateFailure() : super._();
}

class GetFailure extends UserFailure {
  const GetFailure() : super._();
}

class StreamFailure extends UserFailure {
  const StreamFailure() : super._();
}

class UpdateFailure extends UserFailure {
  const UpdateFailure() : super._();
}

class DeleteFailure extends UserFailure {
  const DeleteFailure() : super._();
}
