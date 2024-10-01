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
          var isLiked = false;
          var likes = 0;
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
                  post.creatorId,
                  post.id,
                  liked: isLiked,
                ),
            icon: isLiked
                ? accentIconStyle(context, AppIcons.liked)
                : defaultIconStyle(context, AppIcons.notLiked),
            text: '$likes',
          );
        },
      ),
    );
  }
}
