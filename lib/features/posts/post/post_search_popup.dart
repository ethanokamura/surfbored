import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:rando/features/posts/cubit/post_cubit.dart';
import 'package:rando/features/posts/edit_post/edit_post.dart';
import 'package:rando/features/posts/likes/likes.dart';
import 'package:rando/features/posts/shared/more_options.dart';
import 'package:rando/features/profile/profile.dart';
import 'package:rando/features/tags/tags.dart';
import 'package:user_repository/user_repository.dart';

Future<dynamic> postSearchPopUp(
  BuildContext context,
  Post post,
) async {
  final userID = context.read<UserRepository>().user.uid;
  final isOwner = userID == post.uid;

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Theme.of(context).colorScheme.surface,
    isScrollControlled: true,
    builder: (context) {
      return BlocProvider(
        create: (_) => PostCubit(
          postRepository: context.read<PostRepository>(),
        ), // Create a new PostCubit instance here
        child: Builder(
          builder: (context) {
            final postCubit = context.read<PostCubit>();
            return Column(
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
                      width: double.infinity,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MoreOptions(
                            postID: post.id,
                            userID: userID,
                            isOwner: isOwner,
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
                          LabeledIconButton(
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
                      TitleText(text: post.title),
                      DescriptionText(text: post.description),
                      const VerticalSpacer(),
                      TagList(tags: post.tags),
                      const VerticalSpacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          UserDetails(uid: post.uid),
                          LikeButton(post: post, userID: userID),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}
