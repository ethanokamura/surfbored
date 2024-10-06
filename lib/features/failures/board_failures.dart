import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';

BlocListener<C, S> listenForBoardFailures<C extends Cubit<S>, S>({
  required BoardFailure Function(S state) failureSelector,
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
          AddSaveFailure() => DataStrings.fromAddSaveFailure,
          RemoveSaveFailure() => DataStrings.fromRemoveSaveFailure,
          _ => DataStrings.fromUnknownFailure,
        };
        context.showSnackBar(message);
      }
    },
    child: child,
  );
}
