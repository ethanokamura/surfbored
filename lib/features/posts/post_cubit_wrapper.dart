import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:surfbored/features/failures/post_failures.dart';
import 'package:surfbored/features/posts/cubit/post_cubit.dart';

class PostCubitWrapper extends StatelessWidget {
  const PostCubitWrapper({
    required this.builder,
    super.key,
  });
  final Widget Function(BuildContext, PostState) builder;
  @override
  Widget build(BuildContext context) {
    return listenForPostFailures<PostCubit, PostState>(
      failureSelector: (state) => state.failure,
      isFailureSelector: (state) => state.isFailure,
      child: BlocBuilder<PostCubit, PostState>(builder: builder),
    );
  }
}

Widget loadingPostState(BuildContext context) =>
    const Center(child: CircularProgressIndicator());

Widget emptyPostState(BuildContext context) => Center(
      child: CustomText(
        text: context.l10n.empty,
        style: primaryText,
      ),
    );

Widget updatedPostState(BuildContext context) => Center(
      child: CustomText(
        text: context.l10n.fromUpdate,
        style: primaryText,
      ),
    );

Widget errorPostState(BuildContext context) => Center(
      child: CustomText(
        text: context.l10n.unknownFailure,
        style: primaryText,
      ),
    );
