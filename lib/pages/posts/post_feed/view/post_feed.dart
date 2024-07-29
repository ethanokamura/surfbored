import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:rando/pages/posts/cubit/activity_cubit.dart';
import 'package:rando/pages/posts/shared/post/post.dart';

class PostFeed extends StatelessWidget {
  const PostFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostCubit(
        postRepository: context.read<PostRepository>(),
      )..streamAllPosts(),
      child: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if (state.status == PostStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == PostStatus.empty) {
            return const Center(child: Text('No posts found.'));
          } else if (state.status == PostStatus.failure) {
            return const Center(child: Text('Something went wrong.'));
          } else if (state.status == PostStatus.loaded) {
            final posts = state.posts;
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              separatorBuilder: (context, index) => const VerticalSpacer(),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostView(post: post);
              },
            );
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }
}
