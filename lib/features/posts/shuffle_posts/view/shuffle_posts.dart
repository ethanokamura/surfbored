import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/failures/post_failures.dart';
import 'package:surfbored/features/posts/posts.dart';
import 'package:surfbored/features/posts/shuffle_posts/cubit/shuffle_index_cubit.dart';
import 'package:tag_repository/tag_repository.dart';

class ShuffledPostsPage extends StatelessWidget {
  const ShuffledPostsPage({required this.boardId, super.key});
  final int boardId;
  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      top: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const AppBarText(text: AppBarStrings.shuffledPosts),
      ),
      body: BlocProvider(
        create: (context) => PostCubit(
          postRepository: context.read<PostRepository>(),
          tagRepository: context.read<TagRepository>(),
        )..shufflePostList(boardId),
        child: listenForPostFailures<PostCubit, PostState>(
          failureSelector: (state) => state.failure,
          isFailureSelector: (state) => state.isFailure,
          child: BlocBuilder<PostCubit, PostState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.isLoaded) {
                final posts = state.posts;
                return PostViewController(posts: posts);
              } else if (state.isEmpty) {
                return const Center(
                  child: PrimaryText(text: DataStrings.empty),
                );
              } else {
                return const Center(
                  child: PrimaryText(text: DataStrings.fromUnknownFailure),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class PostViewController extends StatelessWidget {
  const PostViewController({required this.posts, super.key});
  final List<Post> posts;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShuffleIndexCubit(),
      child: BlocBuilder<ShuffleIndexCubit, int>(
        builder: (context, state) {
          return Center(
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PostView(
                  post: posts[state],
                ),
                const VerticalSpacer(),
                Row(
                  children: [
                    Expanded(
                      child: ActionButton(
                        text: ButtonStrings.last,
                        onTap: () {
                          if (state > 0) {
                            context.read<ShuffleIndexCubit>().decrement();
                          }
                        },
                      ),
                    ),
                    const HorizontalSpacer(),
                    Expanded(
                      child: ActionAccentButton(
                        text: ButtonStrings.next,
                        onTap: () {
                          if (state < posts.length - 1) {
                            context.read<ShuffleIndexCubit>().increment();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
