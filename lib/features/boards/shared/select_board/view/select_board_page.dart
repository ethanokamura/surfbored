import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surfbored/features/boards/boards.dart';
import 'package:surfbored/features/boards/shared/select_board/view/board_card.dart';

class SelectBoardPage extends StatelessWidget {
  const SelectBoardPage({
    required this.userID,
    required this.postID,
    super.key,
  });
  final String userID;
  final String postID;
  static MaterialPage<void> page({
    required String postID,
    required String userID,
  }) {
    return MaterialPage<void>(
      child: SelectBoardPage(postID: postID, userID: userID),
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
      body: SelectBoardsList(userID: userID, postID: postID),
    );
  }
}

class SelectBoardsList extends StatelessWidget {
  const SelectBoardsList({
    required this.userID,
    required this.postID,
    super.key,
  });
  final String userID;
  final String postID;
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
            return SelectBoardListView(
              boards: boards,
              postID: postID,
              hasMore: context.read<BoardCubit>().hasMore(),
              onLoadMore: () async =>
                  context.read<BoardCubit>().loadMoreUserBoards(userID),
            );
          } else if (state.isEmpty) {
            return const Center(
              child: PrimaryText(text: AppStrings.emptyPosts),
            );
          } else if (state.isDeleted || state.isUpdated) {
            context.read<BoardCubit>().streamUserBoards(userID);
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
    required this.postID,
    required this.onLoadMore,
    required this.hasMore,
    super.key,
  });
  final List<Board> boards;
  final String postID;
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
          return SelectBoardCard(
            postID: postID,
            board: board,
          );
        },
      ),
    );
  }
}
