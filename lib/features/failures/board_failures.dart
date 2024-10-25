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
          EmptyFailure() => AppStrings.empty,
          CreateFailure() => AppStrings.createFailure,
          ReadFailure() => AppStrings.fetchFailure,
          UpdateFailure() => AppStrings.updateFailure,
          DeleteFailure() => AppStrings.deleteFailure,
          AddSaveFailure() => AppStrings.addSaveFailure,
          RemoveSaveFailure() => AppStrings.removeSaveFailure,
          _ => AppStrings.unknownFailure,
        };
        context.showSnackBar(message);
      }
    },
    child: child,
  );
}
