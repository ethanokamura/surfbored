import 'dart:io';

import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/create/cubit/create_cubit.dart';
import 'package:surfbored/features/tags/tags.dart';
import 'package:user_repository/user_repository.dart';

class CreatePostPage extends StatelessWidget {
  const CreatePostPage._();

  static MaterialPage<dynamic> page() => const MaterialPage<void>(
        key: ValueKey('create_post'),
        child: CreatePostPage._(),
      );

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

  bool _titleIsValid = false;
  bool _descriptionIsValid = false;
  bool _tagsAreValid = false;
  String _title = '';
  String _description = '';
  String _tags = '';
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomPageView(
        top: true,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.transparent,
          title: const AppBarText(text: PageStrings.createPostPage),
        ),
        body: SingleChildScrollView(
          child: Column(
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
                maxLength: 150,
                context: context,
                label: CreateStrings.description,
                onChanged: (value) async => _onDescriptionChanged(value.trim()),
              ),
              const VerticalSpacer(),
              EditTagsPrompt(
                tags: rawTags,
                updateTags: (tags) => setState(() {
                  rawTags = tags;
                  _tags = tags.join('+');
                  _tagsAreValid = true;
                }),
                label: CreateStrings.tagsPrompt,
              ),
              const VerticalSpacer(multiple: 3),
              ActionButton(
                text: _titleIsValid || _descriptionIsValid || _tagsAreValid
                    ? AppStrings.saveChanges
                    : AppStrings.invalidChanges,
                onTap: _titleIsValid || _descriptionIsValid || _tagsAreValid
                    ? () {
                        try {
                          final uuid = context.read<UserRepository>().user.uuid;
                          final data = Post(
                            creatorId: uuid,
                            title: _title,
                            description: _description,
                            tags: _tags,
                          );
                          context.read<CreateCubit>().createPost(post: data);
                        } catch (e) {
                          context.showSnackBar('Unable to save data: $e');
                        }
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
