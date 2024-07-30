import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:post_repository/post_repository.dart';
import 'package:rando/pages/posts/shared/post_popup.dart';

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Hero(
                tag: post.photoURL!,
                child: ImageWidget(
                  photoURL: post.photoURL,
                  height: 128,
                  width: double.infinity,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    post.title,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).textColor,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    post.description,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).subtextColor,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // TagListWidget(tags: post.tags),
          ],
        ),
      ),
    );
  }
}
