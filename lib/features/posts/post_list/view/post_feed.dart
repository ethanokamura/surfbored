import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/misc/unknown/unknown.dart';
import 'package:surfbored/features/posts/cubit/post_cubit.dart';
import 'package:surfbored/features/posts/post/post.dart';
import 'package:surfbored/features/posts/post_cubit_wrapper.dart';
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
      child: PostCubitWrapper(
        loadedFunction: (context, state) {
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
                    ? UnknownCard(message: context.l10n.dataNotFound)
                    : PostView(post: post);
              },
            ),
          );
        },
        updatedFunction: (context, state) =>
            context.read<PostCubit>().fetchAllPosts(refresh: true),
      ),
    );
  }
}
