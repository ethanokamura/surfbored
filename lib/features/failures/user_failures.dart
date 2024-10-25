import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
          EmptyFailure() => AppLocalizations.of(context)!.empty,
          CreateFailure() => AppLocalizations.of(context)!.createFailure,
          GetFailure() => AppLocalizations.of(context)!.fetchFailure,
          UpdateFailure() => AppLocalizations.of(context)!.updateFailure,
          DeleteFailure() => AppLocalizations.of(context)!.deleteFailure,
          AuthChangesFailure() => AppLocalizations.of(context)!.authFailure,
          SignOutFailure() => AppLocalizations.of(context)!.signOutFailure,
          InvalidPhoneNumberFailure() =>
            AppLocalizations.of(context)!.invalidPhoneNumber,
          PhoneNumberSignInFailure() =>
            AppLocalizations.of(context)!.signInFailure,
          _ => AppLocalizations.of(context)!.unknownFailure,
        };
        context.showSnackBar(message);
      }
    },
    child: child,
  );
}
