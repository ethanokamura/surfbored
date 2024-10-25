import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/posts/post/view/shuffled_post.dart';
import 'package:surfbored/features/posts/shuffle_posts/cubit/shuffle_index_cubit.dart';

class ShuffledPostsPage extends StatelessWidget {
  const ShuffledPostsPage({required this.posts, super.key});
  final List<Post> posts;
  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      top: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: AppBarText(text: context.l10n.shuffledPosts),
      ),
      body: PostViewController(posts: posts),
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
                ShuffledPost(post: posts[state]),
                const VerticalSpacer(),
                Row(
                  children: [
                    Expanded(
                      child: ActionButton(
                        text: context.l10n.previous,
                        onTap: () {
                          if (state > 0) {
                            context.read<ShuffleIndexCubit>().decrement();
                          }
                        },
                      ),
                    ),
                    const HorizontalSpacer(),
                    Expanded(
                      child: DefaultButton(
                        text: context.l10n.next,
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
