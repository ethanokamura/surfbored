import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/failures/post_failures.dart';
import 'package:surfbored/features/posts/cubit/post_cubit.dart';
import 'package:surfbored/features/posts/post/post.dart';
import 'package:surfbored/features/unknown/unknown.dart';
import 'package:tag_repository/tag_repository.dart';

class PostFeed extends StatelessWidget {
  const PostFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostCubit(
        postRepository: context.read<PostRepository>(),
        tagRepository: context.read<TagRepository>(),
      )..fetchAllPosts(),
      child: listenForPostFailures<PostCubit, PostState>(
        failureSelector: (state) => state.failure,
        isFailureSelector: (state) => state.isFailure,
        child: BlocBuilder<PostCubit, PostState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.isLoaded) {
              final posts = state.posts;
              return RefreshIndicator(
                onRefresh: () async =>
                    context.read<PostCubit>().fetchAllPosts(refresh: true),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  separatorBuilder: (context, index) => const VerticalSpacer(),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return post.isEmpty
                        ? const UnknownCard(message: DataStrings.emptyFailure)
                        : PostView(post: post);
                  },
                ),
              );
            } else if (state.isEmpty) {
              return const Center(
                child: PrimaryText(text: DataStrings.empty),
              );
            } else if (state.isDeleted || state.isUpdated) {
              context.read<PostCubit>().fetchAllPosts(refresh: true);
              return const Center(
                child: PrimaryText(text: DataStrings.fromUpdate),
              );
            } else if (state.isFailure) {
              return const Center(
                child: PrimaryText(text: DataStrings.fromUnknownFailure),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
