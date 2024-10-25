import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:surfbored/features/boards/board_list/view/board_card.dart';
import 'package:surfbored/features/boards/boards.dart';
import 'package:surfbored/features/failures/board_failures.dart';
import 'package:surfbored/features/unknown/unknown.dart';

class UserBoards extends StatelessWidget {
  const UserBoards({required this.userId, super.key});
  final String userId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BoardCubit(
        boardRepository: context.read<BoardRepository>(),
      )..fetchBoards(userId),
      child: listenForBoardFailures<BoardCubit, BoardState>(
        failureSelector: (state) => state.failure,
        isFailureSelector: (state) => state.isFailure,
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
                onRefresh: () async => context
                    .read<BoardCubit>()
                    .fetchBoards(userId, refresh: true),
              );
            } else if (state.isEmpty) {
              return Center(
                child: PrimaryText(text: context.l10n.empty),
              );
            } else if (state.isDeleted || state.isUpdated) {
              context.read<BoardCubit>().streamUserBoards(userId);
              return Center(
                child: PrimaryText(text: context.l10n.fromUpdate),
              );
            } else if (state.isFailure) {
              return Center(
                child: PrimaryText(text: context.l10n.unknownFailure),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
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
