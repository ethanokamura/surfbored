import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:friend_repository/friend_repository.dart';

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
          EmptyFailure() => context.l10n.empty,
          CreateFailure() => context.l10n.createFailure,
          ReadFailure() => context.l10n.fetchFailure,
          UpdateFailure() => context.l10n.updateFailure,
          DeleteFailure() => context.l10n.deleteFailure,
          _ => context.l10n.unknownFailure,
        };
        context.showSnackBar(message);
      }
    },
    child: child,
  );
}
