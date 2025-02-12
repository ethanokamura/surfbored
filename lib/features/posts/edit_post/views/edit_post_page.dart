import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/images/images.dart';
import 'package:surfbored/features/posts/cubit/post_cubit.dart';
import 'package:surfbored/features/tags/tags.dart';

class EditPostPage extends StatelessWidget {
  const EditPostPage({
    required this.post,
    super.key,
  });
  final Post post;
  static MaterialPage<void> page({required Post post}) {
    return MaterialPage<void>(
      child: EditPostPage(post: post),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomPageView(
        title: context.l10n.edit,
        body: EditPostView(
          post: post,
          postCubit: context.read<PostCubit>(),
        ),
      ),
    );
  }
}

class EditPostView extends StatefulWidget {
  const EditPostView({
    required this.post,
    required this.postCubit,
    super.key,
  });
  final Post post;
  final PostCubit postCubit;

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
  late String? _photoUrl;

  @override
  void initState() {
    _titleController.text = widget.post.title;
    _descriptionController.text = widget.post.description;
    _photoUrl = widget.post.photoUrl;
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
    final postId = widget.post.id!;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// TOOD(Ethan): change this to image upload
          EditImage(
            width: 200,
            // height: 200,
            photoUrl: _photoUrl,
            collection: 'posts',
            userId: widget.post.creatorId,
            docId: postId,
            aspectX: 4,
            aspectY: 3,
            onFileChanged: (url) async {
              await widget.postCubit.uploadImage(postId, url);
              setState(() => _photoUrl = url);
            },
          ),
          const VerticalSpacer(),
          customTextFormField(
            controller: _titleController,
            context: context,
            label: context.l10n.title,
            maxLength: 40,
            onChanged: (value) async => _onTitleChanged(value.trim()),
          ),
          const VerticalSpacer(),
          customTextFormField(
            controller: _descriptionController,
            maxLength: 150,
            context: context,
            label: context.l10n.description,
            onChanged: (value) async => _onDescriptionChanged(value.trim()),
          ),
          const VerticalSpacer(),
          EditTagsPrompt(
            tags: widget.post.tags.split('+'),
            updateTags: (tags) => setState(() {
              rawTags = tags;
              _tags = tags.join('+');
              _tagsAreValid = true;
            }),
            label: context.l10n.tagsPrompt,
          ),
          const VerticalSpacer(),
          CustomButton(
            color: 2,
            text: _titleIsValid || _descriptionIsValid || _tagsAreValid
                ? context.l10n.save
                : context.l10n.invalid,
            onTap: _titleIsValid || _descriptionIsValid || _tagsAreValid
                ? () {
                    try {
                      final data = Post.update(
                        title: _title != '' ? _title : widget.post.title,
                        description: _description != ''
                            ? _description
                            : widget.post.description,
                        tags: _tags != '' ? _tags : widget.post.tags,
                      );
                      context.read<PostCubit>().updatePost(postId, data);
                      Navigator.pop(context);
                    } catch (e) {
                      context.showSnackBar('Unable to save data: $e');
                    }
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
