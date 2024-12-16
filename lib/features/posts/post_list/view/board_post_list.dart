import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/posts/post_cubit_wrapper.dart';
import 'package:surfbored/features/posts/posts.dart';
import 'package:tag_repository/tag_repository.dart';

class BoardPostList extends StatelessWidget {
  const BoardPostList({required this.boardId, super.key});
  final int boardId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostCubit(
        postRepository: context.read<PostRepository>(),
        tagRepository: context.read<TagRepository>(),
      )..fetchBoardPosts(boardId),
      child: PostCubitWrapper(
        builder: (context, state) {
          if (state.isLoading) {
            return loadingPostState(context);
          } else if (state.isLoaded) {
            final posts = state.posts;
            return PostListView(
              posts: posts,
              hasMore: context.read<PostCubit>().hasMorePosts,
              onLoadMore: () async =>
                  context.read<PostCubit>().fetchBoardPosts(boardId),
              onRefresh: () async => context
                  .read<PostCubit>()
                  .fetchBoardPosts(boardId, refresh: true),
            );
          } else if (state.isEmpty) {
            return emptyPostState(context);
          } else if (state.isDeleted || state.isUpdated) {
            context.read<PostCubit>().fetchBoardPosts(boardId);
            return updatedPostState(context);
          }
          return errorPostState(context);
        },
      ),
    );
  }
}
