import 'package:board_repository/board_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/pages/boards/cubit/board_cubit.dart';
import 'package:rando/pages/posts/posts.dart';
import 'package:user_repository/user_repository.dart';

class BoardActivities extends StatelessWidget {
  const BoardActivities({required this.boardID, super.key});
  final String boardID;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BoardCubit(
        boardRepository: context.read<BoardRepository>(),
        userRepository: context.read<UserRepository>(),
      )..streamPosts(boardID),
      child: BlocBuilder<BoardCubit, BoardState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isLoaded) {
            final posts = state.posts;
            return PostsGrid(
              posts: posts,
              onRefresh: () async {
                context
                    .read<BoardCubit>()
                    .streamPosts(boardID); // Refresh the posts
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
