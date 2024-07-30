import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:rando/pages/posts/posts.dart';

class PostList extends StatelessWidget {
  const PostList({required this.userID, super.key});
  final String userID;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostCubit(
        postRepository: context.read<PostRepository>(),
      )..streamUserPosts(userID),
      child: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isLoaded) {
            final posts = state.posts;
            return PostsGrid(
              posts: posts,
              // postCubit: context.read<PostCubit>(),
              onRefresh: () async {
                context.read<PostCubit>().streamUserPosts(userID);
              },
            );
          } else if (state.isEmpty) {
            return const Center(child: Text('Item list is empty.'));
          } else if (state.isDeleted || state.isUpdated || state.isCreated) {
            context.read<PostCubit>().streamUserPosts(userID);
            return const Center(child: Text('Posts were changed. Reloading.'));
          } else if (state.isFailure) {
            return const Center(child: Text('Something went wrong'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
