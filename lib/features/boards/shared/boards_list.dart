import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/features/boards/boards.dart';

class BoardsList extends StatelessWidget {
  const BoardsList({required this.userID, super.key});
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
              boards: boards,
              onRefresh: () async =>
                  context.read<BoardCubit>().streamUserBoards(userID),
            );
          } else if (state.isEmpty) {
            return const Center(child: Text('No boards.'));
          } else if (state.isDeleted || state.isUpdated || state.isCreated) {
            context.read<BoardCubit>().streamUserBoards(userID);
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

class BoardListView extends StatelessWidget {
  const BoardListView({
    required this.onRefresh,
    required this.boards,
    super.key,
  });
  final List<Board> boards;
  final Future<void> Function() onRefresh;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: defaultPadding),
        separatorBuilder: (context, index) => const VerticalSpacer(),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: boards.length,
        itemBuilder: (context, index) {
          final board = boards[index];
          return BoardCard(board: board);
        },
      ),
    );
  }
}
