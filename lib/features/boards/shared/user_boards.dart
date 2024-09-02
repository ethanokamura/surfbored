import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/features/boards/boards.dart';

class UserBoardsList extends StatelessWidget {
  const UserBoardsList({required this.userID, super.key});
  final String userID;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BoardCubit(
        boardRepository: context.read<BoardRepository>(),
      )..streamUserBoards(userID),
      child: BlocBuilder<BoardCubit, BoardState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isLoaded) {
            final boards = state.boards;
            return BoardListView(
              hasMore: context.read<BoardCubit>().hasMore(),
              boards: boards,
              onLoadMore: () async =>
                  context.read<BoardCubit>().loadMoreUserBoards(userID),
            );
          } else if (state.isEmpty) {
            return const Center(child: PrimaryText(text: 'No boards.'));
          } else if (state.isDeleted || state.isUpdated) {
            context.read<BoardCubit>().streamUserBoards(userID);
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

class BoardListView extends StatelessWidget {
  const BoardListView({
    required this.boards,
    required this.onLoadMore,
    required this.hasMore,
    super.key,
  });
  final List<Board> boards;
  final bool hasMore;
  final Future<void> Function() onLoadMore;
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification.metrics.pixels - 25 >=
            scrollNotification.metrics.maxScrollExtent) {
          if (hasMore) onLoadMore();
        }
        return false;
      },
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: defaultPadding),
        separatorBuilder: (context, index) => const VerticalSpacer(),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: boards.length,
        itemBuilder: (context, index) {
          final board = boards[index];
          return BoardCard(board: board);
        },
      ),
    );
  }
}
