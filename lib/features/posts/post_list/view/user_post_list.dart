import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/posts/post_cubit_wrapper.dart';
import 'package:surfbored/features/posts/posts.dart';
import 'package:tag_repository/tag_repository.dart';

class UserPostList extends StatelessWidget {
  const UserPostList({required this.userId, super.key});
  final String userId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostCubit(
        postRepository: context.read<PostRepository>(),
        tagRepository: context.read<TagRepository>(),
      )..fetchUserPosts(userId),
      child: PostCubitWrapper(
        loadedFunction: (context, state) {
          final posts = state.posts;
          return PostListView(
            posts: posts,
            hasMore: context.read<PostCubit>().hasMorePosts,
            onLoadMore: () async =>
                context.read<PostCubit>().fetchUserPosts(userId),
            onRefresh: () async =>
                context.read<PostCubit>().fetchUserPosts(userId, refresh: true),
          );
        },
        updatedFunction: (context, state) =>
            context.read<PostCubit>().fetchUserPosts(userId),
      ),
    );
  }
}
