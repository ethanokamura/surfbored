import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surfbored/features/boards/boards.dart';
import 'package:surfbored/features/boards/shared/select_board/view/board_card.dart';
import 'package:surfbored/features/unknown/unknown.dart';

class SelectBoardPage extends StatelessWidget {
  const SelectBoardPage({
    required this.userId,
    required this.postId,
    super.key,
  });
  final String userId;
  final int postId;
  static MaterialPage<void> page({
    required int postId,
    required String userId,
  }) {
    return MaterialPage<void>(
      child: SelectBoardPage(postId: postId, userId: userId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      top: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const AppBarText(text: AppStrings.addActivity),
      ),
      body: SelectBoardsList(userId: userId, postId: postId),
    );
  }
}

class SelectBoardsList extends StatelessWidget {
  const SelectBoardsList({
    required this.userId,
    required this.postId,
    super.key,
  });
  final String userId;
  final int postId;
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
            return SelectBoardListView(
              boards: boards,
              postId: postId,
              onLoadMore: () async =>
                  context.read<BoardCubit>().fetchBoards(userId),
            );
          } else if (state.isEmpty) {
            return const Center(
              child: PrimaryText(text: AppStrings.emptyPosts),
            );
          } else if (state.isDeleted || state.isUpdated) {
            context.read<BoardCubit>().streamUserBoards(userId);
            return const Center(
              child: PrimaryText(text: AppStrings.changedPosts),
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

class SelectBoardListView extends StatelessWidget {
  const SelectBoardListView({
    required this.boards,
    required this.postId,
    required this.onLoadMore,
    super.key,
  });
  final List<Board> boards;
  final int postId;
  final Future<void> Function() onLoadMore;
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
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
        physics: const NeverScrollableScrollPhysics(),
        itemCount: boards.length,
        itemBuilder: (context, index) {
          final board = boards[index];
          return board.isEmpty
              ? const UnknownCard(message: 'Board not found')
              : SelectBoardCard(
                  postId: postId,
                  board: board,
                );
        },
      ),
    );
  }
}
