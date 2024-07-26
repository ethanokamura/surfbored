import 'package:app_ui/app_ui.dart';
import 'package:boards_repository/boards_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/pages/boards/cubit/board_cubit.dart';
import 'package:user_repository/user_repository.dart';

class SelectBoardCard extends StatelessWidget {
  const SelectBoardCard({
    required this.itemID,
    required this.boardID,
    super.key,
  });
  final String itemID;
  final String boardID;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BoardCubit(
        boardsRepository: context.read<BoardsRepository>(),
        userRepository: context.read<UserRepository>(),
      )..streamBoard(boardID),
      child: BlocBuilder<BoardCubit, BoardState>(
        builder: (context, state) {
          if (state is BoardLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BoardLoaded) {
            final board = state.board;
            return SelectBoardCardView(board: board, itemID: itemID);
          } else if (state is BoardError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }
}

class SelectBoardCardView extends StatelessWidget {
  const SelectBoardCardView({
    required this.board,
    required this.itemID,
    super.key,
  });
  final Board board;
  final String itemID;

  @override
  Widget build(BuildContext context) {
    final selected = board.hasItem(itemID: itemID);

    return GestureDetector(
      onTap: () {
        context
            .read<BoardCubit>()
            .toggleItemSelection(board.id, itemID, isSelected: selected);
      },
      child: CustomContainer(
        inverted: false,
        horizontal: null,
        vertical: null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ImageWidget(
              borderRadius: defaultBorderRadius,
              photoURL: board.photoURL,
              height: 64,
              width: 64,
            ),
            const HorizontalSpacer(),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    board.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    board.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).subtextColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            CheckBox(isSelected: selected),
          ],
        ),
      ),
    );
  }
}
