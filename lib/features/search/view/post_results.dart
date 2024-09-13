import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:post_repository/post_repository.dart';

class PostResults {
  const PostResults(this.items, this.pageKey, this.nextPageKey);
  factory PostResults.fromResponse(SearchResponse response) {
    final items = response.hits.map(Post.fromAlgolia).toList();
    final isLastPage = response.page >= response.nbPages;
    final nextPageKey = isLastPage ? null : response.page + 1;
    return PostResults(items, response.page, nextPageKey);
  }

  final List<Post> items;
  final int pageKey;
  final int? nextPageKey;
}
