import 'package:app_ui/app_ui.dart';
import 'package:comment_repository/comment_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surfbored/features/comments/buttons/like/cubit/comment_likes_cubit.dart';

class CommentLikeButton extends StatelessWidget {
  const CommentLikeButton({
    required this.comment,
    required this.postID,
    required this.userID,
    super.key,
  });

  final Comment comment;
  final String postID;
  final String userID;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommentLikesCubit(context.read<CommentRepository>())
        ..fetchCommentData(postID, comment.id, userID),
      child: BlocBuilder<CommentLikesCubit, CommentLikesState>(
        builder: (context, state) {
          var likes = comment.likes;
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
                  postID,
                  comment.id,
                  userID,
                  liked: isLiked,
                ),
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked
                  ? Theme.of(context).accentColor
                  : Theme.of(context).textColor,
              size: 20,
            ),
            text: likes.toString(),
          );
        },
      ),
    );
  }
}
