import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:surfbored/features/failures/post_failures.dart';
import 'package:surfbored/features/posts/cubit/post_cubit.dart';

class PostCubitWrapper extends StatelessWidget {
  const PostCubitWrapper({
    required this.loadedFunction,
    required this.updatedFunction,
    super.key,
  });
  final Widget Function(BuildContext, PostState) loadedFunction;
  final void Function(BuildContext, PostState) updatedFunction;
  @override
  Widget build(BuildContext context) {
    return listenForPostFailures<PostCubit, PostState>(
      failureSelector: (state) => state.failure,
      isFailureSelector: (state) => state.isFailure,
      child: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isLoaded) {
            loadedFunction(context, state);
          } else if (state.isEmpty) {
            return Center(
              child: PrimaryText(text: context.l10n.empty),
            );
          } else if (state.isDeleted || state.isUpdated) {
            updatedFunction(context, state);
            return Center(child: PrimaryText(text: context.l10n.fromUpdate));
          }
          return Center(
            child: PrimaryText(text: context.l10n.unknownFailure),
          );
        },
      ),
    );
  }
}
