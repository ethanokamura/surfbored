import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:rando/features/posts/cubit/post_cubit.dart';
import 'package:rando/features/posts/edit_post/edit_post.dart';
import 'package:rando/features/posts/likes/likes.dart';
import 'package:rando/features/posts/shared/post/view/more_options.dart';
import 'package:rando/features/profile/profile.dart';
import 'package:rando/features/tags/tags.dart';
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
    final userID = context.read<UserRepository>().user.uid;
    final isOwner = userID == post.uid;
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
                        userID: userID,
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
            TitleText(text: post.title),
            DescriptionText(text: post.description),
            const VerticalSpacer(),
            TagList(tags: post.tags),
            const VerticalSpacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ProfileLink(uid: post.uid),
                LikeButton(post: post, userID: userID),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
