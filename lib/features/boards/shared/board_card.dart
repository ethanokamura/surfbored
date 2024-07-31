import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/features/boards/boards.dart';

class BoardCard extends StatelessWidget {
  const BoardCard({required this.board, super.key});
  final Board board;

  @override
  Widget build(BuildContext context) {
    final boardCubit = context.read<BoardCubit>();
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<dynamic>(
            builder: (context) {
              return BlocProvider.value(
                value: boardCubit,
                child: BoardPage(board: board),
              );
            },
          ),
        );
      },
      child: CustomContainer(
        inverted: false,
        horizontal: null,
        vertical: null,
        child: Row(
          children: [
            SquareImage(
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
          ],
        ),
      ),
    );
  }
}
