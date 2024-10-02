import 'package:app_ui/app_ui.dart';
import 'package:comment_repository/comment_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surfbored/features/comments/buttons/like/cubit/comment_likes_cubit.dart';

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
        ..fetchCommentData(userId, comment.id),
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
            onSurface: true,
            background: false,
            onTap: () async => context.read<CommentLikesCubit>().toggleLike(
                  commentId: comment.id,
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
