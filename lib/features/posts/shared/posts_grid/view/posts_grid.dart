import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:post_repository/post_repository.dart';
import 'package:rando/features/posts/shared/post_card/view/post_card.dart';

class PostsGrid extends StatelessWidget {
  const PostsGrid({
    required this.onLoadMore,
    required this.posts,
    required this.hasMore,
    super.key,
  });
  final List<Post> posts;
  final bool hasMore;
  final Future<void> Function() onLoadMore;

  @override
  Widget build(BuildContext context) {
    final count = posts.length;
    const itemsPerRow = 2;
    const ratio = 0.9;
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification.metrics.pixels - 25 >=
            scrollNotification.metrics.maxScrollExtent) {
          if (hasMore) onLoadMore();
        }
        return false;
      },
      child: GridView.builder(
        padding: const EdgeInsets.only(bottom: defaultPadding),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: itemsPerRow,
          crossAxisSpacing: defaultPadding,
          mainAxisSpacing: defaultPadding,
          childAspectRatio: ratio,
        ),
        itemCount: count,
        itemBuilder: (context, index) {
          final post = posts[index];
          return PostCard(
            post: post,
          );
        },
      ),
    );
  }
}
