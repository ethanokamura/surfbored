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
          EmptyFailure() => context.l10n.empty,
          CreateFailure() => context.l10n.createFailure,
          GetFailure() => context.l10n.fetchFailure,
          UpdateFailure() => context.l10n.updateFailure,
          DeleteFailure() => context.l10n.deleteFailure,
          AuthChangesFailure() => context.l10n.authFailure,
          SignOutFailure() => context.l10n.signOutFailure,
          InvalidPhoneNumberFailure() => context.l10n.invalidPhoneNumber,
          PhoneNumberSignInFailure() => context.l10n.signInFailure,
          _ => context.l10n.unknownFailure,
        };
        context.showSnackBar(message);
      }
    },
    child: child,
  );
}
