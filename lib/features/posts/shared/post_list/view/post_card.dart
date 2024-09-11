import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:post_repository/post_repository.dart';
import 'package:rando/features/posts/post/post_popup.dart';

class PostCard extends StatelessWidget {
  const PostCard({required this.post, super.key});
  final Post post;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => postPopUp(
        context,
        post,
      ),
      child: CustomContainer(
        inverted: false,
        horizontal: 0,
        vertical: 0,
        child: Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageWidget(
                photoURL: post.photoURL,
                width: double.maxFinite,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TitleText(text: post.title, fontSize: 14),
                    DescriptionText(
                      text: post.description,
                      fontSize: 14,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              // TagListWidget(tags: post.tags),
            ],
          ),
        ),
      ),
    );
  }
}
