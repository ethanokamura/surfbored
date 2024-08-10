import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:rando/features/posts/cubit/post_cubit.dart';
import 'package:rando/features/posts/shared/post/post.dart';

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
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isLoaded) {
            final posts = state.posts;
            return RefreshIndicator(
              onRefresh: () async => context.read<PostCubit>().streamAllPosts(),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                separatorBuilder: (context, index) => const VerticalSpacer(),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return PostView(
                    post: post,
                    postCubit: context.read<PostCubit>(),
                  );
                },
              ),
            );
          } else if (state.isEmpty) {
            return const Center(
              child: PrimaryText(text: 'Item list is empty.'),
            );
          } else if (state.isDeleted || state.isUpdated || state.isCreated) {
            context.read<PostCubit>().streamAllPosts();
            return const Center(
              child: PrimaryText(text: 'Posts were changed. Reloading.'),
            );
          } else if (state.isFailure) {
            return const Center(
              child: PrimaryText(text: 'Something went wrong'),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
