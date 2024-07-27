import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/pages/activities/shared/like_button/cubit/like_cubit.dart';

class LikeButton extends StatelessWidget {
  const LikeButton({
    required this.itemID,
    required this.userID,
    required this.isLiked,
    required this.likes,
    super.key,
  });

  final String itemID;
  final String userID;
  final bool isLiked;
  final int likes;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LikeCubit, LikeState>(
      listener: (context, state) {
        if (state is LikeFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        var isCurrentlyLiked = isLiked;
        var currentLikes = likes;

        if (state is LikeLoading) {
          // Show a loading indicator in the button if needed
        } else if (state is LikeSuccess) {
          isCurrentlyLiked = state.isLiked;
          currentLikes += isCurrentlyLiked ? 1 : -1;
        }

        return LikeButtonWidget(
          onTap: () => context
              .read<LikeCubit>()
              .toggleLike(userID, itemID, liked: isCurrentlyLiked),
          likes: currentLikes,
          isLiked: isCurrentlyLiked,
        );
      },
    );
  }
}

class LikeButtonWidget extends StatelessWidget {
  const LikeButtonWidget({
    required this.onTap,
    required this.likes,
    required this.isLiked,
    super.key,
  });

  final void Function()? onTap;
  final int likes;
  final bool isLiked;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked
                ? Theme.of(context).accentColor
                : Theme.of(context).backgroundColor,
          ),
          const SizedBox(width: 10),
          Text('$likes likes'),
        ],
      ),
    );
  }
}
