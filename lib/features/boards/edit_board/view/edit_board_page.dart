// dart packages
import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/features/boards/boards.dart';
import 'package:rando/features/tags/tags.dart';

class EditBoardPage extends StatelessWidget {
  const EditBoardPage({
    required this.boardID,
    required this.onDelete,
    super.key,
  });
  final String boardID;
  final void Function() onDelete;
  static MaterialPage<void> page({
    required String boardID,
    required void Function() onDelete,
  }) {
    return MaterialPage<void>(
      child: EditBoardPage(
        boardID: boardID,
        onDelete: onDelete,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<BoardCubit>().fetchBoard(boardID);
    return CustomPageView(
      top: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const AppBarText(text: 'Edit Board'),
      ),
      body: BlocListener<BoardCubit, BoardState>(
        listener: (context, state) {
          if (state.isUpdated) {
            // Show a success message or navigate back
            context.showSnackBar('Post updated successfully');
          }
        },
        child: BlocBuilder<BoardCubit, BoardState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.isLoaded) {
              return EditView(
                board: state.board,
                boardCubit: context.read<BoardCubit>(),
                onDelete: onDelete,
              );
            } else if (state.isDeleted) {
              return const Center(
                child: PrimaryText(text: 'Deleted board.'),
              );
            }
            return const Center(
              child: PrimaryText(text: 'Something went wrong'),
            );
          },
        ),
      ),
    );
  }
}

class EditView extends StatelessWidget {
  const EditView({
    required this.board,
    required this.boardCubit,
    required this.onDelete,
    super.key,
  });
  final Board board;
  final BoardCubit boardCubit;
  final void Function() onDelete;
  @override
  Widget build(BuildContext context) {
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
          EditField(
            field: 'title',
            value: board.title,
            boardID: board.id,
          ),
          const VerticalSpacer(),
          EditField(
            field: 'description',
            value: board.description,
            boardID: board.id,
          ),
          const VerticalSpacer(),
          EditTagsBox(
            tags: board.tags,
            updateTags: (tags) => boardCubit.editField(board.id, 'tags', tags),
          ),
          const VerticalSpacer(),
          ActionButton(
            inverted: true,
            text: 'Delete Board',
            onTap: () {
              onDelete();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class EditField extends StatelessWidget {
  const EditField({
    required this.field,
    required this.value,
    required this.boardID,
    super.key,
  });
  final String field;
  final String value;
  final String boardID;
  @override
  Widget build(BuildContext context) {
    return CustomTextBox(
      text: value,
      label: field,
      onPressed: () async {
        final newValue = await editTextField(
          context,
          field,
          30,
          TextEditingController(),
        );
        if (newValue != null && context.mounted) {
          await context.read<BoardCubit>().editField(boardID, field, newValue);
        }
      },
    );
  }
}
