import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:comment_repository/comment_repository.dart';
import 'package:surfbored/features/comments/comments_page/comment/comment_likes/cubit/comment_likes_cubit.dart';

class CommentLikeButton extends StatelessWidget {
  const CommentLikeButton({
    required this.comment,
    required this.userId,
    super.key,
  });

  final Comment comment;
  final String userId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommentLikesCubit(context.read<CommentRepository>())
        ..fetchData(userId, comment.id!),
      child: BlocBuilder<CommentLikesCubit, CommentLikesState>(
        builder: (context, state) {
          var likes = 0;
          var isLiked = false;
          if (state.isLoading) {
            // print('loading');
            // Show a loading indicator in the button if needed
          } else if (state.isSuccess) {
            // print('loaded');
            likes = state.likes;
            isLiked = state.liked;
          }
          return ToggleButton(
            onTap: () async => context.read<CommentLikesCubit>().toggleLike(
                  commentId: comment.id!,
                  userId: userId,
                  liked: isLiked,
                ),
            icon: isLiked
                ? accentIconStyle(context, AppIcons.liked)
                : defaultIconStyle(context, AppIcons.notLiked),
            text: likes.toString(),
          );
        },
      ),
    );
  }
}
