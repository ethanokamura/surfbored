import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:friend_repository/friend_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

BlocListener<C, S> listenForFriendFailures<C extends Cubit<S>, S>({
  required FriendFailure Function(S state) failureSelector,
  required bool Function(S state) isFailureSelector,
  required Widget child,
}) {
  return BlocListener<C, S>(
    listenWhen: (_, current) => isFailureSelector(current),
    listener: (context, state) {
      if (isFailureSelector(state)) {
        final failure = failureSelector(state);
        final message = switch (failure) {
          EmptyFailure() => AppLocalizations.of(context)!.empty,
          CreateFailure() => AppLocalizations.of(context)!.createFailure,
          ReadFailure() => AppLocalizations.of(context)!.fetchFailure,
          UpdateFailure() => AppLocalizations.of(context)!.updateFailure,
          DeleteFailure() => AppLocalizations.of(context)!.deleteFailure,
          _ => AppLocalizations.of(context)!.unknownFailure,
        };
        context.showSnackBar(message);
      }
    },
    child: child,
  );
}
