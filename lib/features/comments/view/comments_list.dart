import 'package:app_ui/app_ui.dart';
import 'package:comment_repository/comment_repository.dart';
import 'package:surfbored/features/comments/comment/comment.dart';
import 'package:surfbored/features/unknown/unknown.dart';

class CommentListView extends StatelessWidget {
  const CommentListView({
    required this.comments,
    required this.postId,
    super.key,
  });
  final List<Comment> comments;
  final int postId;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      reverse: true,
      padding: const EdgeInsets.only(bottom: defaultPadding),
      separatorBuilder: (context, index) => const VerticalSpacer(),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: comments.length,
      itemBuilder: (context, index) {
        final comment = comments[index];
        return comment.isEmpty
            ? const UnknownCard(message: 'Comment not found.')
            : CommentCard(comment: comment, postId: postId);
      },
    );
  }
}
