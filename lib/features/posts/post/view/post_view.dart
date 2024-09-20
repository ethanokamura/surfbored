import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/posts/cubit/post_cubit.dart';
import 'package:surfbored/features/posts/edit_post/edit_post.dart';
import 'package:surfbored/features/posts/likes/likes.dart';
import 'package:surfbored/features/posts/shared/more_options.dart';
import 'package:surfbored/features/profile/profile.dart';
import 'package:surfbored/features/tags/tags.dart';
import 'package:user_repository/user_repository.dart';

class PostView extends StatelessWidget {
  const PostView({
    required this.post,
    required this.postCubit,
    super.key,
  });
  final Post post;
  final PostCubit postCubit;
  @override
  Widget build(BuildContext context) {
    final userID = context.read<UserRepository>().user.uid;
    return Flexible(
      child: CustomContainer(
        inverted: false,
        horizontal: null,
        vertical: null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.photoURL != null && post.photoURL! != '')
              ImageHeader(post: post, userID: userID, postCubit: postCubit)
            else
              Header(post: post, userID: userID, postCubit: postCubit),
            if (post.photoURL != null && post.photoURL! != '')
              const VerticalSpacer(),
            PostDetails(title: post.title, description: post.description),
            const VerticalSpacer(),
            TagList(tags: post.tags),
            const VerticalSpacer(),
            Footer(post: post, userID: userID),
          ],
        ),
      ),
    );
  }
}

class ImageHeader extends StatelessWidget {
  const ImageHeader({
    required this.post,
    required this.userID,
    required this.postCubit,
    super.key,
  });
  final Post post;
  final String userID;
  final PostCubit postCubit;
  @override
  Widget build(BuildContext context) {
    final isOwner = userID == post.uid;
    return Stack(
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
                  if (Navigator.canPop(context)) Navigator.pop(context);
                  await postCubit.deletePost(
                    post.uid,
                    post.id,
                    post.photoURL.toString(),
                  );
                  if (context.mounted && Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    required this.post,
    required this.userID,
    required this.postCubit,
    super.key,
  });
  final Post post;
  final String userID;
  final PostCubit postCubit;
  @override
  Widget build(BuildContext context) {
    final isOwner = userID == post.uid;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        MoreOptions(
          onSurface: true,
          postID: post.id,
          userID: userID,
          isOwner: isOwner,
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
            if (Navigator.canPop(context)) Navigator.pop(context);
            await postCubit.deletePost(
              post.uid,
              post.id,
              post.photoURL.toString(),
            );
            if (context.mounted && Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}

class PostDetails extends StatelessWidget {
  const PostDetails({
    required this.title,
    required this.description,
    super.key,
  });
  final String title;
  final String description;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(text: title),
        DescriptionText(text: description),
      ],
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({required this.post, required this.userID, super.key});
  final Post post;
  final String userID;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        UserDetails(uid: post.uid),
        LikeButton(post: post, userID: userID),
      ],
    );
  }
}
