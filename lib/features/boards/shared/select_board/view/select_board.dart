import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/features/boards/shared/select_board/cubit/selection_cubit.dart';

class SelectBoardCard extends StatelessWidget {
  const SelectBoardCard({
    required this.board,
    required this.postID,
    super.key,
  });
  final Board board;
  final String postID;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SelectionCubit(context.read<BoardRepository>()),
      child: BlocBuilder<SelectionCubit, SelectionState>(
        builder: (context, state) {
          var isSelected = board.hasPost(postID: postID);
          if (state is SelectionLoading) {
            // Show a loading indicator in the button if needed
          } else if (state is SelectionSuccess) {
            isSelected = state.isSelected;
          }
          return GestureDetector(
            onTap: () {
              context
                  .read<SelectionCubit>()
                  .toggleSelection(board.id, postID, isSelected: isSelected);
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
                  CheckBox(isSelected: isSelected),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
