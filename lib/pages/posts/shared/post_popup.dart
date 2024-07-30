import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:rando/pages/posts/cubit/post_cubit.dart';
import 'package:rando/pages/posts/edit_post/edit_post.dart';
import 'package:rando/pages/posts/shared/post/cubit/like_cubit.dart';
import 'package:rando/pages/posts/shared/post/view/more_options.dart';
import 'package:rando/pages/profile/profile/profile.dart';
import 'package:user_repository/user_repository.dart';

Future<dynamic> postPopUp(
  BuildContext context,
  Post post,
) async {
  final postCubit = context.read<PostCubit>();
  final user = context.read<UserRepository>().fetchCurrentUser();
  final isOwner = context.read<UserRepository>().isCurrentUser(post.uid);

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Theme.of(context).colorScheme.surface,
    isScrollControlled: true,
    builder: (context) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            ImageWidget(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(defaultRadius),
                topRight: Radius.circular(defaultRadius),
              ),
              photoURL: post.photoURL,
              height: 256,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MoreOptions(
                    postID: post.id,
                    userID: post.uid,
                    isOwner: isOwner,
                    imgURL: post.photoURL.toString(),
                    onEdit: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (context) {
                            return BlocProvider.value(
                              value: postCubit,
                              child: EditPostPage(postID: post.id),
                            );
                          },
                        ),
                      );
                    },
                    onDelete: () async {
                      Navigator.pop(context);
                      await postCubit.deletePost(
                        post.uid,
                        post.id,
                        post.photoURL.toString(),
                      );
                      if (context.mounted) Navigator.pop(context);
                    },
                  ),
                  ActionIconButton(
                    icon: FontAwesomeIcons.xmark,
                    size: 20,
                    inverted: false,
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: defaultPadding,
            right: defaultPadding,
            top: defaultPadding,
            bottom: 60,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title,
                style: TextStyle(
                  color: Theme.of(context).textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              Text(
                post.description,
                style: TextStyle(
                  color: Theme.of(context).subtextColor,
                  fontSize: 18,
                ),
              ),
              const VerticalSpacer(),
              TagList(tags: post.tags),
              const VerticalSpacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LinkWidget(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (context) => ProfilePage(userID: post.uid),
                      ),
                    ),
                    text: '@${user.username}',
                  ),
                  BlocProvider(
                    create: (context) =>
                        LikeCubit(context.read<PostRepository>()),
                    child: BlocBuilder<LikeCubit, LikeState>(
                      builder: (context, state) {
                        var isCurrentlyLiked =
                            user.hasLikedPost(postID: post.id);
                        var likes = post.likes;
                        if (state is LikeLoading) {
                          // Show a loading indicator in the button if needed
                        } else if (state is LikeSuccess) {
                          isCurrentlyLiked = state.isLiked;
                          likes = state.likes;
                        }
                        return LikeButton(
                          onTap: () => context.read<LikeCubit>().toggleLike(
                                user.uid,
                                post.id,
                                liked: isCurrentlyLiked,
                              ),
                          isLiked: isCurrentlyLiked,
                          likes: likes,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
