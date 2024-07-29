import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/pages/boards/cubit/board_cubit.dart';
import 'package:user_repository/user_repository.dart';

class SelectBoardCard extends StatelessWidget {
  const SelectBoardCard({
    required this.postID,
    required this.boardID,
    super.key,
  });
  final String postID;
  final String boardID;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BoardCubit(
        boardRepository: context.read<BoardRepository>(),
        userRepository: context.read<UserRepository>(),
      )..getBoard(boardID),
      child: BlocBuilder<BoardCubit, BoardState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isLoaded) {
            final board = state.board;
            return SelectBoardCardView(board: board, postID: postID);
          } else if (state.isEmpty) {
            return const Center(child: Text('This board is empty.'));
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }
}

class SelectBoardCardView extends StatelessWidget {
  const SelectBoardCardView({
    required this.board,
    required this.postID,
    super.key,
  });
  final Board board;
  final String postID;

  @override
  Widget build(BuildContext context) {
    final selected = board.hasPost(postID: postID);

    return GestureDetector(
      onTap: () {
        context
            .read<BoardCubit>()
            .toggleSelection(board.id, postID, isSelected: selected);
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
