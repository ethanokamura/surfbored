import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:surfbored/features/boards/boards.dart';
import 'package:surfbored/features/boards/select_board/view/select_board_card.dart';

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
      title: context.l10n.addToBoard,
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
            return Center(
              child: CustomText(
                text: context.l10n.empty,
                style: primaryText,
              ),
            );
          } else if (state.isDeleted || state.isUpdated) {
            context.read<BoardCubit>().streamUserBoards(userId);
            return Center(
              child: CustomText(
                text: context.l10n.fromUpdate,
                style: primaryText,
              ),
            );
          } else if (state.isFailure) {
            return Center(
              child: CustomText(
                text: context.l10n.fetchFailure,
                style: primaryText,
              ),
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
