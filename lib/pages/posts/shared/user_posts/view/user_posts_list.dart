import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:rando/pages/posts/posts.dart';

class UserPostsList extends StatelessWidget {
  const UserPostsList({required this.userID, super.key});
  final String userID;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostCubit(
        postRepository: context.read<PostRepository>(),
      )..streamUserPosts(userID),
      child: BlocListener<PostCubit, PostState>(
        listener: (context, state) {
          if (state.isLoading && state.posts.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Loading Posts'),
                duration: Duration(milliseconds: 500),
              ),
            );
          } else if (state.isDeleted || state.isUpdated || state.isCreated) {
            context.read<PostCubit>().streamUserPosts(userID);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Posts were changed. Reloading.'),
                duration: Duration(seconds: 1),
              ),
            );
          }
        },
        child: BlocBuilder<PostCubit, PostState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.isLoaded) {
              final posts = state.posts;
              return PostsGrid(
                hasMore: context.read<PostCubit>().hasMore(),
                posts: posts,
                onLoadMore: () async =>
                    context.read<PostCubit>().loadMoreUserPosts(userID),
                onRefresh: () async {
                  context.read<PostCubit>().streamUserPosts(userID);
                },
              );
            } else if (state.isEmpty) {
              return const Center(child: Text('Item list is empty.'));
            } else if (state.isDeleted || state.isUpdated || state.isCreated) {
              context.read<PostCubit>().streamUserPosts(userID);
              return const Center(
                  child: Text('Posts were changed. Reloading.'));
            } else if (state.isFailure) {
              return const Center(child: Text('Something went wrong'));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
