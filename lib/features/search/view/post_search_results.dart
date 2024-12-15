import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/posts/post_cubit_wrapper.dart';
import 'package:surfbored/features/posts/posts.dart';
import 'package:tag_repository/tag_repository.dart';

class PostSearchResults extends StatelessWidget {
  const PostSearchResults({required this.query, super.key});
  final String query;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostCubit(
        postRepository: context.read<PostRepository>(),
        tagRepository: context.read<TagRepository>(),
      )..searchPosts(query, refresh: true),
      child: PostCubitWrapper(
        loadedFunction: (context, state) {
          final posts = state.posts;
          return PostListView(
            posts: posts,
            hasMore: context.read<PostCubit>().hasMorePosts,
            onLoadMore: () async =>
                context.read<PostCubit>().searchPosts(query),
            onRefresh: () async =>
                context.read<PostCubit>().searchPosts(query, refresh: true),
          );
        },
        updatedFunction: (context, state) =>
            context.read<PostCubit>().searchPosts(query, refresh: true),
      ),
    );
  }
}
