import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:user_repository/user_repository.dart';

BlocListener<C, S> listenForUserFailures<C extends Cubit<S>, S>({
  required UserFailure Function(S state) failureSelector,
  required bool Function(S state) isFailureSelector,
  required Widget child,
}) {
  return BlocListener<C, S>(
    listenWhen: (_, current) => isFailureSelector(current),
    listener: (context, state) {
      if (isFailureSelector(state)) {
        final failure = failureSelector(state);
        final message = switch (failure) {
          EmptyFailure() => DataStrings.emptyFailure,
          CreateFailure() => DataStrings.fromCreateFailure,
          GetFailure() => DataStrings.fromGetFailure,
          UpdateFailure() => DataStrings.fromUpdateFailure,
          DeleteFailure() => DataStrings.fromDeleteFailure,
          AuthChangesFailure() => AuthStrings.authFailure,
          SignOutFailure() => AuthStrings.signOutFailure,
          InvalidPhoneNumberFailure() => AuthStrings.invalidPhoneNumber,
          PhoneNumberSignInFailure() => AuthStrings.signInFailure,
          _ => DataStrings.fromUnknownFailure,
        };
        context.showSnackBar(message);
      }
    },
    child: child,
  );
}
