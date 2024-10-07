import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:surfbored/features/boards/boards.dart';
import 'package:surfbored/features/failures/board_failures.dart';
import 'package:surfbored/features/images/images.dart';

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
        title: const AppBarText(text: BoardStrings.edit),
      ),
      body: listenForBoardFailures<BoardCubit, BoardState>(
        failureSelector: (state) => state.failure,
        isFailureSelector: (state) => state.isFailure,
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
                child: PrimaryText(text: BoardStrings.delete),
              );
            }
            return const Center(
              child: PrimaryText(text: BoardStrings.failure),
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
    final boardId = board.id!;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EditImage(
            width: 200,
            // height: 200,
            photoUrl: board.photoUrl,
            collection: 'boards',
            userId: board.creatorId,
            docId: boardId,
            aspectX: 4,
            aspectY: 3,
            onFileChanged: (url) {
              boardCubit.editField(boardId, Board.photoUrlConverter, url);
            },
          ),
          const VerticalSpacer(),
          EditField(
            field: Board.titleConverter,
            value: board.title,
            boardId: boardId,
          ),
          const VerticalSpacer(),
          EditField(
            field: Board.descriptionConverter,
            value: board.description,
            boardId: boardId,
          ),
          const VerticalSpacer(),
          ActionButton(
            inverted: true,
            text: BoardStrings.delete,
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
