import 'package:app_ui/app_ui.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/search/view/post_search_card.dart';
import 'package:surfbored/features/unknown/unknown.dart';

class SearchPostListView extends StatelessWidget {
  const SearchPostListView({
    required this.posts,
    required this.onLoadMore,
    required this.onRefresh,
    required this.hasMore,
    super.key,
  });
  final List<Post> posts;
  final Future<void> Function() onLoadMore;
  final Future<void> Function() onRefresh;
  final bool hasMore;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: defaultPadding),
      separatorBuilder: (context, index) => const VerticalSpacer(),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return post.isEmpty
            ? const UnknownCard(message: 'Post not found')
            : PostSearchCard(post: post);
      },
    );
  }
}
