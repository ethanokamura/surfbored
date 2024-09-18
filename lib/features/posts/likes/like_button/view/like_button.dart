import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/posts/likes/cubit/like_cubit.dart';

class LikeButton extends StatelessWidget {
  const LikeButton({required this.post, required this.userID, super.key});
  final Post post;
  final String userID;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LikeCubit(context.read<PostRepository>()),
      child: BlocBuilder<LikeCubit, LikeState>(
        builder: (context, state) {
          context.read<LikeCubit>().fetchData(post.id, userID);
          var likes = post.likes;
          var isLiked = false;
          if (state.isLoading) {
            // Show a loading indicator in the button if needed
          } else if (state.isSuccess) {
            likes = state.likes;
            isLiked = state.liked;
          }
          return ToggleButton(
            onSurface: true,
            onTap: () => context.read<LikeCubit>().toggleLike(
                  userID,
                  post.uid,
                  post.id,
                  liked: isLiked,
                ),
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked
                  ? Theme.of(context).accentColor
                  : Theme.of(context).textColor,
              size: 20,
            ),
            text: '$likes',
          );
        },
      ),
    );
  }
}
