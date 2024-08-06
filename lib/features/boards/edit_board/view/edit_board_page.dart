// dart packages
import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/features/boards/boards.dart';

class EditBoardPage extends StatefulWidget {
  const EditBoardPage({required this.boardID, super.key});
  final String boardID;
  static MaterialPage<void> page({required String boardID}) {
    return MaterialPage<void>(
      child: EditBoardPage(boardID: boardID),
    );
  }

  @override
  State<EditBoardPage> createState() => _EditBoardPageState();
}

class _EditBoardPageState extends State<EditBoardPage> {
  @override
  void initState() {
    super.initState();
    context.read<BoardCubit>().streamBoard(widget.boardID);
  }

  @override
  Widget build(BuildContext context) {
    final boardCubit = context.read<BoardCubit>();
    return CustomPageView(
      top: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const AppBarText(text: 'Edit Board'),
      ),
      body: BlocBuilder<BoardCubit, BoardState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isLoaded || state.isUpdated) {
            return EditView(board: state.board, boardCubit: boardCubit);
          } else {
            return const Center(
              child: PrimaryText(text: 'Something went wrong'),
            );
          }
        },
      ),
    );
  }
}

class EditView extends StatelessWidget {
  const EditView({required this.board, required this.boardCubit, super.key});
  final Board board;
  final BoardCubit boardCubit;
  @override
  Widget build(BuildContext context) {
    return BlocListener<BoardCubit, BoardState>(
      listener: (context, state) {
        if (state.isUpdated) {
          // Show a success message or navigate back
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: PrimaryText(text: 'Post updated successfully'),
            ),
          );
        }
      },
      child: BlocBuilder<BoardCubit, BoardState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                EditImage(
                  width: 200,
                  // height: 200,
                  photoURL: board.photoURL,
                  collection: 'users',
                  docID: board.uid,
                  onFileChanged: (url) {
                    boardCubit.editField(board.id, 'photoURL', url);
                  },
                ),
                const VerticalSpacer(),
                CustomTextBox(
                  text: board.title,
                  label: 'title',
                  onPressed: () async {
                    final newValue = await editTextField(
                      context,
                      'title',
                      30,
                      TextEditingController(),
                    );
                    if (newValue != null && context.mounted) {
                      await boardCubit.editField(board.id, 'title', newValue);
                    }
                  },
                ),
                const VerticalSpacer(),
                CustomTextBox(
                  text: board.description,
                  label: 'description',
                  onPressed: () async {
                    final newValue = await editTextField(
                      context,
                      'description',
                      150,
                      TextEditingController(),
                    );
                    if (newValue != null && context.mounted) {
                      await boardCubit.editField(
                        board.id,
                        'description',
                        newValue,
                      );
                    }
                  },
                ),
                const VerticalSpacer(),
                ActionButton(
                  inverted: true,
                  text: 'Delete Board',
                  onTap: () => boardCubit.deleteBoard(
                    board.uid,
                    board.id,
                    board.photoURL!,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
