import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/boards/boards.dart';
import 'package:surfbored/features/comments/comments.dart';
import 'package:surfbored/features/posts/cubit/post_cubit.dart';
import 'package:surfbored/features/posts/edit_post/edit_post.dart';
import 'package:surfbored/features/posts/likes/likes.dart';
import 'package:surfbored/features/profile/profile.dart';
import 'package:surfbored/features/tags/tags.dart';
import 'package:user_repository/user_repository.dart';

Future<dynamic> postPopUp(
  BuildContext context,
  Post post,
) async {
  final postCubit = context.read<PostCubit>();
  final userID = context.read<UserRepository>().user.id;
  final isOwner = userID == post.uid;

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
            if (post.photoURL != null && post.photoURL! != '')
              ImageWidget(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(defaultRadius),
                  topRight: Radius.circular(defaultRadius),
                ),
                photoURL: post.photoURL,
                // height: 256,
                width: double.infinity,
              ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MoreOptions(
                    onSurface: !(post.photoURL != null && post.photoURL! != ''),
                    isOwner: isOwner,
                    onManage: () => Navigator.push(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (context) => SelectBoardPage(
                          postID: post.id,
                          userID: userID,
                        ),
                      ),
                    ),
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
                    onSurface: !(post.photoURL != null && post.photoURL! != ''),
                    icon: AppIcons.cancel,
                    inverted: false,
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
            left: defaultPadding,
            right: defaultPadding,
            top: post.photoURL != null && post.photoURL! != ''
                ? defaultPadding
                : 0,
            bottom: 60,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText(text: post.title),
              if (post.description.isNotEmpty)
                DescriptionText(text: post.description),
              if (post.description.isNotEmpty) const VerticalSpacer(),
              if (post.website.isNotEmpty) WebLink(url: post.website),
              if (post.website.isNotEmpty) const VerticalSpacer(),
              if (post.tags.isNotEmpty) TagList(tags: post.tags),
              if (post.tags.isNotEmpty) const VerticalSpacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UserDetails(id: post.uid),
                  Row(
                    children: [
                      CommentButton(
                        postID: post.id,
                        userID: post.uid,
                        comments: post.comments,
                      ),
                      const HorizontalSpacer(),
                      LikeButton(post: post, userID: userID),
                    ],
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
