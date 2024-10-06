import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:post_repository/post_repository.dart';

BlocListener<C, S> listenForPostFailures<C extends Cubit<S>, S>({
  required PostFailure Function(S state) failureSelector,
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
          ReadFailure() => DataStrings.fromGetFailure,
          UpdateFailure() => DataStrings.fromUpdateFailure,
          DeleteFailure() => DataStrings.fromDeleteFailure,
          AddLikeFailure() => DataStrings.fromAddLikeFailure,
          RemoveLikeFailure() => DataStrings.fromRemoveLikeFailure,
          _ => DataStrings.fromUnknownFailure,
        };
        context.showSnackBar(message);
      }
    },
    child: child,
  );
}
