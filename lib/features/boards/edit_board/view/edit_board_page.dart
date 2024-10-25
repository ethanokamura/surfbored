import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:surfbored/features/boards/boards.dart';
import 'package:surfbored/features/images/images.dart';

class EditBoardPage extends StatelessWidget {
  const EditBoardPage({
    required this.boardId,
    required this.board,
    required this.onDelete,
    super.key,
  });
  final int boardId;
  final Board board;
  final void Function() onDelete;
  static MaterialPage<void> page({
    required int boardId,
    required Board board,
    required void Function() onDelete,
  }) {
    return MaterialPage<void>(
      child: EditBoardPage(
        boardId: boardId,
        board: board,
        onDelete: onDelete,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      top: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: AppBarText(text: context.l10n.editBoard),
      ),
      body: EditBoardView(
        board: board,
        boardCubit: context.read<BoardCubit>(),
        onDelete: onDelete,
      ),
    );
  }
}

class EditBoardView extends StatefulWidget {
  const EditBoardView({
    required this.board,
    required this.boardCubit,
    required this.onDelete,
    super.key,
  });
  final Board board;
  final BoardCubit boardCubit;
  final void Function() onDelete;

  @override
  State<EditBoardView> createState() => _EditBoardViewState();
}

class _EditBoardViewState extends State<EditBoardView> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _titleIsValid = false;
  bool _descriptionIsValid = false;
  String _title = '';
  String _description = '';

  @override
  void initState() {
    _titleController.text = widget.board.title;
    _descriptionController.text = widget.board.description;
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _onTitleChanged(String title) async {
    // use regex
    if (title.length < 40 && title.length > 2) {
      setState(() {
        _titleIsValid = true;
        _title = title;
      });
    } else {
      setState(() => _titleIsValid = false);
    }
  }

  Future<void> _onDescriptionChanged(String description) async {
    // use regex
    if (description.length < 150 && description.length > 2) {
      setState(() {
        _descriptionIsValid = true;
        _description = description;
      });
    } else {
      setState(() => _descriptionIsValid = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final boardId = widget.board.id!;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EditImage(
            width: 200,
            // height: 200,
            photoUrl: widget.boardCubit.state.photoUrl,
            collection: 'boards',
            userId: widget.board.creatorId,
            docId: boardId,
            aspectX: 4,
            aspectY: 3,
            onFileChanged: (url) {
              widget.boardCubit.uploadImage(boardId, url);
            },
          ),
          const VerticalSpacer(),
          customTextFormField(
            controller: _titleController,
            context: context,
            label: context.l10n.title,
            maxLength: 40,
            onChanged: (value) async => _onTitleChanged(value.trim()),
            validator: (title) =>
                title != null && title.length < 3 && title.length > 20
                    ? 'Invalid Title'
                    : null,
          ),
          const VerticalSpacer(),
          customTextFormField(
            controller: _descriptionController,
            context: context,
            label: context.l10n.description,
            maxLength: 150,
            onChanged: (value) async => _onDescriptionChanged(value.trim()),
          ),
          const VerticalSpacer(),
          ActionButton(
            text: _titleIsValid || _descriptionIsValid
                ? context.l10n.save
                : context.l10n.invalid,
            onTap: _titleIsValid || _descriptionIsValid
                ? () {
                    try {
                      final data = Board.update(
                        title: _title,
                        description: _description,
                      );
                      context.read<BoardCubit>().updateBoard(boardId, data);
                    } catch (e) {
                      if (!context.mounted) return;
                      context.showSnackBar('Unable to save data: $e');
                    }
                  }
                : null,
          ),
          const VerticalSpacer(),
          ActionButton(
            text: context.l10n.delete,
            onTap: () {
              widget.onDelete();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
