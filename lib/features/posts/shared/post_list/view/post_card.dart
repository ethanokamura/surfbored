import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/posts/posts.dart';

class PostCard extends StatelessWidget {
  const PostCard({required this.post, super.key});
  final Post post;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => postPopUp(context, post),
      child: CustomContainer(
        inverted: false,
        horizontal: null,
        vertical: null,
        child: Row(
          children: [
            if (post.photoURL != null && post.photoURL! != '')
              SquareImage(
                borderRadius: defaultBorderRadius,
                photoURL: post.photoURL,
                height: 64,
                width: 64,
              ),
            if (post.photoURL != null && post.photoURL! != '')
              const HorizontalSpacer(),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TitleText(text: post.title),
                  SecondaryText(text: post.description, maxLines: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
