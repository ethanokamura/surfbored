// dart packages
import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surfbored/features/boards/boards.dart';
import 'package:surfbored/features/tags/tags.dart';

class EditBoardPage extends StatelessWidget {
  const EditBoardPage({
    required this.boardId,
    required this.onDelete,
    super.key,
  });
  final int boardId;
  final void Function() onDelete;
  static MaterialPage<void> page({
    required int boardId,
    required void Function() onDelete,
  }) {
    return MaterialPage<void>(
      child: EditBoardPage(
        boardId: boardId,
        onDelete: onDelete,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<BoardCubit>().fetchBoard(boardId);
    return CustomPageView(
      top: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const AppBarText(text: AppStrings.editBoard),
      ),
      body: BlocListener<BoardCubit, BoardState>(
        listener: (context, state) {
          if (state.isUpdated) {
            // Show a success message or navigate back
            context.showSnackBar(AppStrings.updatedBoard);
          }
        },
        child: BlocBuilder<BoardCubit, BoardState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.isLoaded) {
              return EditView(
                board: state.board,
                boardTags: state.tags,
                boardCubit: context.read<BoardCubit>(),
                onDelete: onDelete,
              );
            } else if (state.isDeleted) {
              return const Center(
                child: PrimaryText(text: AppStrings.deleteBoard),
              );
            }
            return const Center(
              child: PrimaryText(text: AppStrings.fetchFailure),
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
    required this.boardTags,
    required this.boardCubit,
    required this.onDelete,
    super.key,
  });
  final Board board;
  final List<String> boardTags;
  final BoardCubit boardCubit;
  final void Function() onDelete;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EditImage(
            width: 200,
            // height: 200,
            photoUrl: board.photoUrl,
            collection: 'boards',
            docID: board.id,
            onFileChanged: (url) {
              boardCubit.editField(board.id, 'photo_url', url);
            },
          ),
          const VerticalSpacer(),
          EditField(
            field: 'title',
            value: board.title,
            boardId: board.id,
          ),
          const VerticalSpacer(),
          EditField(
            field: 'description',
            value: board.description,
            boardId: board.id,
          ),
          const VerticalSpacer(),
          EditTagsBox(
            tags: boardTags,
            updateTags: (tags) => boardCubit.updateTags(board.id, tags),
          ),
          const VerticalSpacer(),
          ActionButton(
            inverted: true,
            text: AppStrings.deleteBoard,
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

// dynamic input length maximum
int maxInputLength(String field) {
  switch (field) {
    case 'title':
      return 40;
    case 'description':
      return 150;
    default:
      return 50;
  }
}

class EditField extends StatelessWidget {
  const EditField({
    required this.field,
    required this.value,
    required this.boardId,
    super.key,
  });
  final String field;
  final String value;
  final int boardId;
  @override
  Widget build(BuildContext context) {
    return CustomTextBox(
      text: value,
      label: field,
      onPressed: () async {
        final newValue = await editTextField(
          context,
          field,
          TextEditingController(),
        );
        if (newValue != null && context.mounted) {
          await context.read<BoardCubit>().editField(boardId, field, newValue);
        }
      },
    );
  }
}
