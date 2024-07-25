import 'package:app_ui/app_ui.dart';
import 'package:boards_repository/boards_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/pages/boards/cubit/board_cubit.dart';
import 'package:rando/pages/boards/widgets/board_card/board_card.dart';
import 'package:user_repository/user_repository.dart';

class BoardsList extends StatelessWidget {
  const BoardsList({required this.userID, super.key});
  final String userID;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BoardCubit(
        boardsRepository: context.read<BoardsRepository>(),
        userRepository: context.read<UserRepository>(),
      )..streamUserBoards(userID).listen((state) {
          context.read<BoardCubit>();
        }),
      child: BlocBuilder<BoardCubit, BoardState>(
        builder: (context, state) {
          if (state is UserBoardsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BoardError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is UserBoardsLoaded) {
            final boards = state.boards;
            return BoardListView(boards: boards);
          } else {
            return const Text(
              'No Boards Found. Check Database.',
              textAlign: TextAlign.center,
            );
          }
        },
      ),
    );
  }
}

class BoardListView extends StatelessWidget {
  const BoardListView({required this.boards, super.key});
  final List<String> boards;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const VerticalSpacer(),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: boards.length,
      itemBuilder: (context, index) {
        final boardID = boards[index];
        return BoardCard(boardID: boardID);
      },
    );
  }
}
