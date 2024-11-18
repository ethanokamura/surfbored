import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:surfbored/features/create/cubit/create_cubit.dart';

class CreateBoardPage extends StatelessWidget {
  const CreateBoardPage({super.key});

  static MaterialPage<dynamic> page() =>
      const MaterialPage<void>(child: CreateBoardPage());

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

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _onTitleChanged(BuildContext context, String title) async {
    // use regex
    if (title.length < 40 && title.length > 2) {
      context.read<CreateCubit>().setTitle(title);
    }
  }

  Future<void> _onDescriptionChanged(
    BuildContext context,
    String description,
  ) async {
    // use regex
    if (description.length < 150 && description.length > 2) {
      context.read<CreateCubit>().setDescription(description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleText(text: context.l10n.createPrompt),
          const VerticalSpacer(),
          customTextFormField(
            controller: _titleController,
            context: context,
            label: context.l10n.title,
            maxLength: 40,
            onChanged: (value) async => _onTitleChanged(context, value.trim()),
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
            onChanged: (value) async =>
                _onDescriptionChanged(context, value.trim()),
          ),
        ],
      ),
    );
  }
}
