import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:post_repository/post_repository.dart';
import 'package:rando/features/posts/post/post_search_popup.dart';

class PostSearchCard extends StatelessWidget {
  const PostSearchCard({required this.post, super.key});
  final Post post;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => postSearchPopUp(context, post),
      child: CustomContainer(
        inverted: false,
        horizontal: null,
        vertical: null,
        child: Row(
          children: [
            SquareImage(
              borderRadius: defaultBorderRadius,
              photoURL: post.photoURL,
              height: 64,
              width: 64,
            ),
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
