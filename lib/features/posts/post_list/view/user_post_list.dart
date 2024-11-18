import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/failures/post_failures.dart';
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
      child: listenForPostFailures<PostCubit, PostState>(
        failureSelector: (state) => state.failure,
        isFailureSelector: (state) => state.isFailure,
        child: BlocBuilder<PostCubit, PostState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.isLoaded) {
              final posts = state.posts;
              return PostListView(
                posts: posts,
                hasMore: context.read<PostCubit>().hasMorePosts,
                onLoadMore: () async =>
                    context.read<PostCubit>().fetchUserPosts(userId),
                onRefresh: () async => context
                    .read<PostCubit>()
                    .fetchUserPosts(userId, refresh: true),
              );
            } else if (state.isEmpty) {
              return Center(
                child: PrimaryText(text: context.l10n.empty),
              );
            } else if (state.isDeleted || state.isUpdated) {
              context.read<PostCubit>().fetchUserPosts(userId);
              return Center(
                child: PrimaryText(text: context.l10n.fromUpdate),
              );
            }
            return Center(
              child: PrimaryText(text: context.l10n.unknownFailure),
            );
          },
        ),
      ),
    );
  }
}
