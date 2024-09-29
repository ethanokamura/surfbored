import 'package:app_core/app_core.dart';

class UserFailure extends Failure {
  const UserFailure._();

  // user data retrieval
  factory UserFailure.fromGetUser() => const GetUserFailure();
  factory UserFailure.fromCreateUser() => const CreateUserFailure();
  factory UserFailure.fromUpdateUser() => const UpdateUserFailure();
  factory UserFailure.fromDeleteUser() => const DeleteUserFailure();

  // username data retrieval
  factory UserFailure.fromGetUsername() => const GetUsernameFailure();
  factory UserFailure.fromCreateUsername() => const CreateUsernameFailure();
  factory UserFailure.fromUpdateUsername() => const UpdateUsernameFailure();
  factory UserFailure.fromDeleteUsername() => const DeleteUsernameFailure();

  // auth
  factory UserFailure.fromAuthUserChanges() => const AuthUserChangesFailure();
  factory UserFailure.fromAnonymousSignIn() => const AnonymousSignInFailure();
  factory UserFailure.fromSignOut() => const SignOutFailure();
  factory UserFailure.fromInvalidPhoneNumber() =>
      const InvalidPhoneNumberFailure();
  factory UserFailure.fromPhoneNumberSignIn() =>
      const PhoneNumberSignInFailure();

  static const empty = EmptyUserFailure();
}

class EmptyUserFailure extends UserFailure {
  const EmptyUserFailure() : super._();
}

class AnonymousSignInFailure extends UserFailure {
  const AnonymousSignInFailure() : super._();
}

class InvalidPhoneNumberFailure extends UserFailure {
  const InvalidPhoneNumberFailure() : super._();
}

class AuthUserChangesFailure extends UserFailure {
  const AuthUserChangesFailure() : super._();

  @override
  bool get needsReauthentication => true;
}

class PhoneNumberSignInFailure extends UserFailure {
  const PhoneNumberSignInFailure() : super._();
}

class SignOutFailure extends UserFailure {
  const SignOutFailure() : super._();
}

class GetUserFailure extends UserFailure {
  const GetUserFailure() : super._();
}

class CreateUserFailure extends UserFailure {
  const CreateUserFailure() : super._();
}

class UpdateUserFailure extends UserFailure {
  const UpdateUserFailure() : super._();
}

class DeleteUserFailure extends UserFailure {
  const DeleteUserFailure() : super._();
}

class GetUsernameFailure extends UserFailure {
  const GetUsernameFailure() : super._();
}

class CreateUsernameFailure extends UserFailure {
  const CreateUsernameFailure() : super._();
}

class UpdateUsernameFailure extends UserFailure {
  const UpdateUsernameFailure() : super._();
}

class DeleteUsernameFailure extends UserFailure {
  const DeleteUsernameFailure() : super._();
}
