// dart packages
import 'package:app_ui/app_ui.dart';
import 'package:boards_repository/boards_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/pages/boards/cubit/board_cubit.dart';
import 'package:user_repository/user_repository.dart';

class EditBoardPage extends StatelessWidget {
  const EditBoardPage({required this.boardID, super.key});
  final String boardID;
  static MaterialPage<void> page({required String boardID}) {
    return MaterialPage<void>(
      child: EditBoardPage(boardID: boardID),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Board'),
      ),
      body: BlocProvider(
        create: (_) => BoardCubit(
          boardsRepository: context.read<BoardsRepository>(),
          userRepository: context.read<UserRepository>(),
        )..streamBoard(boardID),
        child: BlocBuilder<BoardCubit, BoardState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.isLoaded) {
              return EditView(board: state.board);
            } else if (state.isEmpty) {
              return const Center(child: Text('This board is empty.'));
            } else {
              return const Center(child: Text('Something went wrong'));
            }
          },
        ),
      ),
    );
  }
}

class EditView extends StatelessWidget {
  const EditView({required this.board, super.key});
  final Board board;
  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      top: true,
      child: SingleChildScrollView(
        child: Column(
          children: [
            EditImage(
              width: 200,
              height: 200,
              photoURL: board.photoURL,
              collection: 'users',
              docID: board.uid,
              onFileChanged: (url) {
                context.read<BoardCubit>().editField(board.id, 'photoURL', url);
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
                  await context
                      .read<BoardCubit>()
                      .editField(board.id, 'title', newValue);
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
                  await context
                      .read<BoardCubit>()
                      .editField(board.id, 'description', newValue);
                }
              },
            ),
            const VerticalSpacer(),
            ActionButton(
              inverted: true,
              text: 'Delete Board',
              onTap: () => context.read<BoardCubit>().deleteBoard(
                    board.uid,
                    board.id,
                    board.photoURL!,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
