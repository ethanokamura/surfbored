import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:comment_repository/comment_repository.dart';

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
          EmptyFailure() => AppStrings.empty,
          CreateFailure() => AppStrings.createFailure,
          ReadFailure() => AppStrings.fetchFailure,
          UpdateFailure() => AppStrings.updateFailure,
          DeleteFailure() => AppStrings.deleteFailure,
          AddLikeFailure() => AppStrings.addLikeFailure,
          RemoveLikeFailure() => AppStrings.removeLikeFailure,
          _ => AppStrings.unknownFailure,
        };
        context.showSnackBar(message);
      }
    },
    child: child,
  );
}
