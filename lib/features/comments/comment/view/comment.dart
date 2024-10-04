import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:comment_repository/comment_repository.dart';
import 'package:surfbored/features/comments/comments.dart';
import 'package:surfbored/features/comments/cubit/comments_cubit.dart';
import 'package:surfbored/features/profile/profile.dart';
import 'package:user_repository/user_repository.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({
    required this.comment,
    required this.postId,
    super.key,
  });
  final Comment comment;
  final int postId;

  @override
  Widget build(BuildContext context) {
    final userId = context.read<UserRepository>().user.uuid;
    final isOwner = userId == comment.senderId;
    return CustomContainer(
      vertical: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UserDetails(id: comment.senderId),
              if (isOwner)
                MoreCommentOptions(
                  onSurface: true,
                  onDelete: () async =>
                      context.read<CommentsCubit>().deleteComment(comment.id),
                ),
            ],
          ),
          const VerticalSpacer(),
          DescriptionText(text: comment.message),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CommentLikeButton(
                comment: comment,
                userId: userId,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
