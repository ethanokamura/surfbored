import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:user_repository/user_repository.dart';

BlocListener<C, S> listenForUserFailures<C extends Cubit<S>, S>({
  required UserFailure Function(S state) failureSelector,
  required bool Function(S state) isFailureSelector,
  required Widget child,
}) {
  return BlocListener<C, S>(
    listenWhen: (previous, current) =>
        !isFailureSelector(previous) && isFailureSelector(current),
    listener: (context, state) {
      if (isFailureSelector(state)) {
        final failure = failureSelector(state);
        final message = switch (failure) {
          EmptyFailure() => AppStrings.empty,
          CreateFailure() => AppStrings.createFailure,
          GetFailure() => AppStrings.fetchFailure,
          UpdateFailure() => AppStrings.updateFailure,
          DeleteFailure() => AppStrings.deleteFailure,
          AuthChangesFailure() => AppStrings.authFailure,
          SignOutFailure() => AppStrings.signOutFailure,
          InvalidPhoneNumberFailure() => AppStrings.invalidPhoneNumber,
          PhoneNumberSignInFailure() => AppStrings.signInFailure,
          _ => AppStrings.unknownFailure,
        };
        context.showSnackBar(message);
      }
    },
    child: child,
  );
}
