import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:rando/pages/posts/posts.dart';

class BoardActivities extends StatelessWidget {
  const BoardActivities({required this.boardID, super.key});
  final String boardID;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostCubit(
        postRepository: context.read<PostRepository>(),
      )..streamBoardPosts(boardID),
      child: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isLoaded) {
            final posts = state.posts;
            return PostsGrid(
              posts: posts,
              onRefresh: () async {
                context
                    .read<PostCubit>()
                    .streamBoardPosts(boardID); // Refresh the posts
              },
            );
          } else if (state.isEmpty) {
            return const Center(child: Text('Board is empty.'));
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }
}
