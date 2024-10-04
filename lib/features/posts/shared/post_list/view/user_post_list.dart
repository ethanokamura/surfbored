import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/posts/posts.dart';
import 'package:surfbored/features/posts/shared/post_list/view/post_list_view.dart';
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
      child: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isLoaded) {
            final posts = state.posts;
            return PostListView(
              posts: posts,
              onLoadMore: () async =>
                  context.read<PostCubit>().fetchUserPosts(userId),
              onRefresh: () async => context
                  .read<PostCubit>()
                  .fetchUserPosts(userId, refresh: true),
            );
          } else if (state.isEmpty) {
            return const Center(
              child: PrimaryText(text: AppStrings.emptyPosts),
            );
          } else if (state.isDeleted || state.isUpdated) {
            context.read<PostCubit>().fetchUserPosts(userId);
            return const Center(
              child: PrimaryText(text: AppStrings.changedPosts),
            );
          }
          return const Center(
            child: PrimaryText(text: AppStrings.fetchFailure),
          );
        },
      ),
    );
  }
}
