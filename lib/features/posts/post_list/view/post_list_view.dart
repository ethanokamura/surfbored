import 'package:app_ui/app_ui.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/posts/post_list/view/post_card.dart';
import 'package:surfbored/features/unknown/unknown.dart';

class PostListView extends StatelessWidget {
  const PostListView({
    required this.posts,
    required this.onLoadMore,
    required this.onRefresh,
    required this.hasMore,
    this.scrollController,
    super.key,
  });
  final List<Post> posts;
  final Future<void> Function() onLoadMore;
  final Future<void> Function() onRefresh;
  final bool hasMore;
  final ScrollController? scrollController;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification.metrics.pixels - 25 >=
                  scrollNotification.metrics.maxScrollExtent &&
              hasMore) {
            onLoadMore();
          }
          return false;
        },
        child: ListView.separated(
          controller: scrollController,
          padding: const EdgeInsets.only(bottom: defaultPadding),
          separatorBuilder: (context, index) => const VerticalSpacer(),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return post.isEmpty
                ? const UnknownCard(message: 'Post not found')
                : PostCard(post: post);
          },
        ),
      ),
    );
  }
}
