import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:post_repository/post_repository.dart';
import 'package:rando/features/posts/shared/post_card/view/post_card.dart';

class PostsGrid extends StatelessWidget {
  const PostsGrid({
    required this.onRefresh,
    required this.onLoadMore,
    required this.posts,
    required this.hasMore,
    super.key,
  });
  final List<Post> posts;
  final bool hasMore;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onLoadMore;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification.metrics.pixels - 25 >=
              scrollNotification.metrics.maxScrollExtent) {
            if (hasMore) onLoadMore();
          }
          return false;
        },
        child: GridView.builder(
          padding: const EdgeInsets.only(bottom: defaultPadding),
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return PostCard(
              post: post,
            );
          },
        ),
      ),
    );
  }
}
