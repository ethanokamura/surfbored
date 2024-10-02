import 'package:app_ui/app_ui.dart';
import 'package:comment_repository/comment_repository.dart';
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
  final userId = context.read<UserRepository>().user.uuid;
  final isOwner = userId == post.creatorId;

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
            if (post.photoUrl != null && post.photoUrl! != '')
              ImageWidget(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(defaultRadius),
                  topRight: Radius.circular(defaultRadius),
                ),
                photoUrl: post.photoUrl,
                // height: 256,
                width: double.infinity,
              ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MoreOptions(
                    onSurface: !(post.photoUrl != null && post.photoUrl! != ''),
                    isOwner: isOwner,
                    onManage: () => Navigator.push(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (context) => SelectBoardPage(
                          postId: post.id!,
                          userId: userId!,
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
                              child: EditPostPage(postId: post.id!),
                            );
                          },
                        ),
                      );
                    },
                    onDelete: () async {
                      Navigator.pop(context);
                      await postCubit.deletePost(
                        post.creatorId,
                        post.id!,
                        post.photoUrl.toString(),
                      );
                      if (context.mounted) Navigator.pop(context);
                    },
                  ),
                  ActionIconButton(
                    onSurface: !(post.photoUrl != null && post.photoUrl! != ''),
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
            top: post.photoUrl != null && post.photoUrl! != ''
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
              if (post.websiteUrl.isNotEmpty) WebLink(url: post.websiteUrl),
              if (post.websiteUrl.isNotEmpty) const VerticalSpacer(),
              FutureBuilder(
                future: context.read<PostCubit>().fetchTags(post.id!),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final tags = snapshot.data!;
                    return Column(
                      children: [
                        TagList(tags: tags),
                        const VerticalSpacer(),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UserDetails(id: post.creatorId),
                  FutureBuilder(
                    future: context
                        .read<CommentRepository>()
                        .fetchTotalComments(postId: post.id!),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Row(
                          children: [
                            CommentButton(
                              postId: post.id!,
                              comments: snapshot.data!,
                            ),
                            const HorizontalSpacer(),
                            LikeButton(post: post, userId: userId!),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
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
