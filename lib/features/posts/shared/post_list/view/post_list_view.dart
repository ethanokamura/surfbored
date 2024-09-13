import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:post_repository/post_repository.dart';
import 'package:rando/features/posts/posts.dart';

class PostListView extends StatelessWidget {
  const PostListView({
    required this.posts,
    required this.onLoadMore,
    required this.onRefresh,
    required this.hasMore,
    super.key,
  });
  final List<Post> posts;
  final bool hasMore;
  final Future<void> Function() onLoadMore;
  final Future<void> Function() onRefresh;
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
        child: ListView.separated(
          padding: const EdgeInsets.only(bottom: defaultPadding),
          separatorBuilder: (context, index) => const VerticalSpacer(),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return PostSearchCard(post: post);
          },
        ),
      ),
    );
  }
}
