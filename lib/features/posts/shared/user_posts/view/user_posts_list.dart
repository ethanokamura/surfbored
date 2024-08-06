import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:rando/features/posts/posts.dart';

class UserPostsList extends StatelessWidget {
  const UserPostsList({required this.userID, super.key});
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
              hasMore: context.read<PostCubit>().hasMore(),
              posts: posts,
              onLoadMore: () async =>
                  context.read<PostCubit>().loadMoreUserPosts(userID),
              onRefresh: () async {
                context.read<PostCubit>().streamUserPosts(userID);
              },
            );
          } else if (state.isEmpty) {
            return const Center(
              child: PrimaryText(text: 'Item list is empty.'),
            );
          } else if (state.isDeleted || state.isUpdated || state.isCreated) {
            context.read<PostCubit>().streamUserPosts(userID);
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
      // ),
    );
  }
}
