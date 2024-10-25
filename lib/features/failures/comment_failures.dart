import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:comment_repository/comment_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

BlocListener<C, S> listenForCommentFailures<C extends Cubit<S>, S>({
  required CommentFailure Function(S state) failureSelector,
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
          AddLikeFailure() => AppLocalizations.of(context)!.addLikeFailure,
          RemoveLikeFailure() =>
            AppLocalizations.of(context)!.removeLikeFailure,
          _ => AppLocalizations.of(context)!.unknownFailure,
        };
        context.showSnackBar(message);
      }
    },
    child: child,
  );
}
