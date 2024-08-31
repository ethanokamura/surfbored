import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:rando/features/posts/posts.dart';

class BoardPosts extends StatelessWidget {
  const BoardPosts({required this.boardID, super.key});
  final String boardID;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostCubit(
        postRepository: context.read<PostRepository>(),
      )..streamBoardPosts(boardID),
      child: BlocListener<PostCubit, PostState>(
        listener: (context, state) {
          if (state.isLoading && state.posts.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Loading Posts'),
                duration: Duration(milliseconds: 500),
              ),
            );
          } else if (state.isDeleted || state.isUpdated) {
            context.read<PostCubit>().streamBoardPosts(boardID);
            context.showSnackBar('Posts were changed. Reloading.');
          }
        },
        child: BlocBuilder<PostCubit, PostState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.isLoaded) {
              final posts = state.posts;
              return PostsGrid(
                posts: posts,
                hasMore: context.read<PostCubit>().hasMore(),
                onLoadMore: () async =>
                    context.read<PostCubit>().loadMoreBoardPosts(boardID),
                onRefresh: () async {
                  context
                      .read<PostCubit>()
                      .streamBoardPosts(boardID); // Refresh the posts
                },
              );
            } else if (state.isEmpty) {
              return const Center(child: PrimaryText(text: 'Board is empty.'));
            } else {
              return const Center(
                child: PrimaryText(text: 'Something went wrong'),
              );
            }
          },
        ),
      ),
    );
  }
}
