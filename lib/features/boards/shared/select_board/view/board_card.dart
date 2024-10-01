import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surfbored/features/boards/shared/select_board/cubit/selection_cubit.dart';

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
          var isSelected = false;
          if (state is SelectionLoading) {
            // Show a loading indicator in the button if needed
          } else if (state is SelectionSuccess) {
            isSelected = state.isSelected;
          }
          return GestureDetector(
            onTap: () {
              context.read<SelectionCubit>().toggleSelection(
                    boardId: board.id,
                    postId: postID,
                    isSelected: isSelected,
                  );
            },
            child: CustomContainer(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SquareImage(
                    borderRadius: defaultBorderRadius,
                    photoUrl: board.photoUrl,
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
                        TitleText(text: board.title),
                        DescriptionText(
                          text: board.description,
                          maxLines: 2,
                          fontSize: 14,
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
