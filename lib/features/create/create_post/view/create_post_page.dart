import 'dart:io';

import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:surfbored/features/create/cubit/create_cubit.dart';
import 'package:surfbored/features/tags/tags.dart';

class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key});

  static MaterialPage<dynamic> page() =>
      const MaterialPage<void>(child: CreatePostPage());

  @override
  Widget build(BuildContext context) {
    return const EditPostView();
  }
}

class EditPostView extends StatefulWidget {
  const EditPostView({super.key});
  @override
  State<EditPostView> createState() => _EditPostViewState();
}

class _EditPostViewState extends State<EditPostView> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  List<String> rawTags = [];

  String? photoUrl;
  File? imageFile;
  String? filename;

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
          CustomText(text: context.l10n.createPrompt, style: titleText),
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
            maxLength: 150,
            context: context,
            label: context.l10n.description,
            onChanged: (value) async =>
                _onDescriptionChanged(context, value.trim()),
          ),
          const VerticalSpacer(),
          EditTagsPrompt(
            tags: rawTags,
            updateTags: (tags) {
              setState(() {
                rawTags = tags;
              });
              context.read<CreateCubit>().setTags(tags.join('+'));
            },
            label: context.l10n.tagsPrompt,
          ),
        ],
      ),
    );
  }
}
