import 'package:app_ui/app_ui.dart';
import 'package:boards_repository/boards_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/pages/activities/add_activity/cubit/add_activity_cubit.dart';
import 'package:user_repository/user_repository.dart';

class SelectBoardCard extends StatefulWidget {
  const SelectBoardCard({
    required this.itemID,
    required this.boardID,
    super.key,
  });
  final String itemID;
  final String boardID;

  @override
  State<SelectBoardCard> createState() => _SelectBoardCardState();
}

class _SelectBoardCardState extends State<SelectBoardCard> {
  late AddActivityCubit boardCubit;
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    boardCubit = AddActivityCubit(
      boardsRepository: context.read<BoardsRepository>(),
      userRepository: context.read<UserRepository>(),
    )
      ..checkIfIncluded(widget.boardID, widget.itemID)
      ..streamBoard(widget.boardID);
  }

  void toggleSelect() {
    if (mounted) setState(() => _isSelected = !_isSelected);
    boardCubit.toggleItemSelection(widget.boardID, widget.itemID, _isSelected);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => boardCubit,
      child: BlocBuilder<AddActivityCubit, AddActivityState>(
        builder: (context, state) {
          if (state is BoardLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BoardLoaded) {
            final board = state.board;
            return CustomContainer(
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
                  CheckBox(isSelected: _isSelected, onTap: toggleSelect),
                ],
              ),
            );
          } else if (state is BoardItemChecked) {
            if (mounted) setState(() => _isSelected = state.isIncluded);
            return Container(); // Return an empty container while checking
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
