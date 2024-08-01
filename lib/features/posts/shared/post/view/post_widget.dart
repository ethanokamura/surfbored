import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:rando/features/posts/cubit/post_cubit.dart';
import 'package:rando/features/posts/edit_post/edit_post.dart';
import 'package:rando/features/posts/shared/post/cubit/like_cubit.dart';
import 'package:rando/features/posts/shared/post/view/more_options.dart';
import 'package:rando/features/shared/shared.dart';
import 'package:user_repository/user_repository.dart';

class PostView extends StatelessWidget {
  const PostView({
    required this.postCubit,
    required this.post,
    super.key,
  });
  final Post post;
  final PostCubit postCubit;
  @override
  Widget build(BuildContext context) {
    final user = context.read<UserRepository>().fetchCurrentUser();
    final isOwner = context.read<UserRepository>().isCurrentUser(post.uid);
    return Flexible(
      child: CustomContainer(
        inverted: false,
        horizontal: null,
        vertical: null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ImageWidget(
                  borderRadius: defaultBorderRadius,
                  photoURL: post.photoURL,
                  // height: 256,
                  width: double.infinity,
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MoreOptions(
                        postID: post.id,
                        userID: post.uid,
                        isOwner: isOwner,
                        imgURL: post.photoURL.toString(),
                        onEdit: () {
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
                          await postCubit.deletePost(
                            post.uid,
                            post.id,
                            post.photoURL.toString(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const VerticalSpacer(),
            Text(
              post.title,
              style: TextStyle(
                color: Theme.of(context).textColor,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            Text(
              post.description,
              style: TextStyle(
                color: Theme.of(context).subtextColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const VerticalSpacer(),
            TagList(tags: post.tags),
            const VerticalSpacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LinkButton(uid: post.uid),
                BlocProvider(
                  create: (context) =>
                      LikeCubit(context.read<PostRepository>()),
                  child: BlocBuilder<LikeCubit, LikeState>(
                    builder: (context, state) {
                      var isCurrentlyLiked = user.hasLikedPost(postID: post.id);
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
    );
  }
}
