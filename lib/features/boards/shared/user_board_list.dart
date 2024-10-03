import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surfbored/features/boards/boards.dart';
import 'package:surfbored/features/unknown/unknown.dart';

class UserBoardsList extends StatelessWidget {
  const UserBoardsList({required this.userId, super.key});
  final String userId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BoardCubit(
        boardRepository: context.read<BoardRepository>(),
      )..fetchBoards(userId),
      child: BlocBuilder<BoardCubit, BoardState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isLoaded) {
            final boards = state.boards;
            return BoardListView(
              boards: boards,
              onLoadMore: () async =>
                  context.read<BoardCubit>().fetchBoards(userId),
              onRefresh: () async =>
                  context.read<BoardCubit>().fetchBoards(userId, refresh: true),
            );
          } else if (state.isEmpty) {
            return const Center(
              child: PrimaryText(text: AppStrings.emptyBoards),
            );
          } else if (state.isDeleted || state.isUpdated) {
            context.read<BoardCubit>().streamUserBoards(userId);
            return const Center(
              child: PrimaryText(text: AppStrings.changedBoards),
            );
          } else if (state.isFailure) {
            return const Center(
              child: PrimaryText(text: AppStrings.fetchFailure),
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
    required this.onRefresh,
    super.key,
  });
  final List<Board> boards;
  final Future<void> Function() onLoadMore;
  final Future<void> Function() onRefresh;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification.metrics.pixels - 25 >=
              scrollNotification.metrics.maxScrollExtent) {
            onLoadMore();
          }
          return false;
        },
        child: ListView.separated(
          padding: const EdgeInsets.only(bottom: defaultPadding),
          separatorBuilder: (context, index) => const VerticalSpacer(),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: boards.length,
          itemBuilder: (context, index) {
            final board = boards[index];
            return board.isEmpty
                ? const UnknownCard(message: 'Board not found')
                : BoardCard(board: board);
          },
        ),
      ),
    );
  }
}
