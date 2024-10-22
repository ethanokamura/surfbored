import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:surfbored/features/create/cubit/create_cubit.dart';
import 'package:user_repository/user_repository.dart';

class CreateBoardPage extends StatelessWidget {
  const CreateBoardPage._();

  static MaterialPage<dynamic> page() => const MaterialPage<void>(
        key: ValueKey('create_board'),
        child: CreateBoardPage._(),
      );

  @override
  Widget build(BuildContext context) {
    return const EditBoardView();
  }
}

class EditBoardView extends StatefulWidget {
  const EditBoardView({super.key});
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customTextFormField(
              controller: _titleController,
              context: context,
              label: CreateStrings.title,
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
              label: CreateStrings.description,
              maxLength: 150,
              onChanged: (value) async => _onDescriptionChanged(value.trim()),
            ),
          ],
        ),
        ActionButton(
          text: _titleIsValid || _descriptionIsValid
              ? AppStrings.saveChanges
              : AppStrings.invalidChanges,
          onTap: _titleIsValid || _descriptionIsValid
              ? () {
                  try {
                    final uuid = context.read<UserRepository>().user.uuid;
                    final data = Board(
                      creatorId: uuid,
                      title: _title,
                      description: _description,
                    );
                    context.read<CreateCubit>().createBoard(board: data);
                  } catch (e) {
                    if (!context.mounted) return;
                    context.showSnackBar('Unable to save data: $e');
                  }
                }
              : null,
        ),
      ],
    );
  }
}
