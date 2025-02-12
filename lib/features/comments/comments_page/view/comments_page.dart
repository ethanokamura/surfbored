import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:comment_repository/comment_repository.dart';
import 'package:surfbored/features/comments/comments_page/cubit/comments_cubit.dart';
import 'package:surfbored/features/comments/comments_page/view/comments_list.dart';
import 'package:surfbored/features/failures/comment_failures.dart';
import 'package:user_repository/user_repository.dart';

class CommentsPage extends StatelessWidget {
  const CommentsPage({
    required this.postId,
    required this.postCreatorId,
    super.key,
  });
  final int postId;
  final String postCreatorId;
  static MaterialPage<void> page({
    required int postId,
    required String postCreatorId,
  }) {
    return MaterialPage<void>(
      child: CommentsPage(postCreatorId: postCreatorId, postId: postId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomPageView(
        title: context.l10n.comments,
        body: BlocProvider<CommentsCubit>(
          create: (context) => CommentsCubit(
            commentRepository: context.read<CommentRepository>(),
          )..readComments(postId),
          child: listenForCommentFailures<CommentsCubit, CommentsState>(
            failureSelector: (state) => state.failure,
            isFailureSelector: (state) => state.isFailure,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(child: CommentsView(postId: postId)),
                const VerticalSpacer(),
                CommentContorller(postCreatorId: postCreatorId, postId: postId),
                const VerticalSpacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CommentsView extends StatelessWidget {
  const CommentsView({
    required this.postId,
    super.key,
  });
  final int postId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentsCubit, CommentsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.isLoaded) {
          final comments = state.comments;
          return CommentListView(comments: comments, postId: postId);
        } else if (state.isEmpty) {
          return Center(
            child: CustomText(
              text: context.l10n.empty,
              style: primaryText,
            ),
          );
        }
        return Center(
          child: CustomText(
            text: context.l10n.unknownFailure,
            style: primaryText,
          ),
        );
      },
    );
  }
}

class CommentContorller extends StatefulWidget {
  const CommentContorller({
    required this.postId,
    required this.postCreatorId,
    super.key,
  });
  final String postCreatorId;
  final int postId;

  @override
  State<CommentContorller> createState() => _CommentContorllerState();
}

class _CommentContorllerState extends State<CommentContorller> {
  final textController = TextEditingController();
  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: CustomContainer(
            vertical: 0,
            child: TextField(
              controller: textController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Write a comment!',
              ),
            ),
          ),
        ),
        CustomButton(
          color: 3,
          icon: AppIcons.message,
          onTap: () async {
            if (textController.text.trim().isNotEmpty) {
              await context.read<CommentsCubit>().createComment(
                    postId: widget.postId,
                    postCreatorId: widget.postCreatorId,
                    senderId: context.read<UserRepository>().user.uuid,
                    message: textController.text.trim(),
                  );
            }
            textController.clear();
          },
        ),
      ],
    );
  }
}
