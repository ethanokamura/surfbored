import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/failures/post_failures.dart';
import 'package:surfbored/features/images/images.dart';
import 'package:surfbored/features/posts/cubit/post_cubit.dart';
import 'package:surfbored/features/tags/tags.dart';

class EditPostPage extends StatelessWidget {
  const EditPostPage({
    required this.postId,
    super.key,
  });
  final int postId;
  static MaterialPage<void> page({required int postId}) {
    return MaterialPage<void>(
      child: EditPostPage(postId: postId),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<PostCubit>().fetchPost(postId);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomPageView(
        top: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const AppBarText(text: AppStrings.edit),
        ),
        body: BlocListener<PostCubit, PostState>(
          listener: (context, state) {
            if (state.isUpdated) {
              // Show a success message or navigate back
              context.showSnackBar(AppStrings.fromUpdate);
            }
          },
          child: listenForPostFailures<PostCubit, PostState>(
            failureSelector: (state) => state.failure,
            isFailureSelector: (state) => state.isFailure,
            child: BlocBuilder<PostCubit, PostState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.isLoaded) {
                  return EditView(
                    post: state.post,
                    postTags: state.tags,
                    postCubit: context.read<PostCubit>(),
                  );
                } else if (state.isDeleted) {
                  return const Center(
                    child: PrimaryText(text: AppStrings.delete),
                  );
                }
                return const Center(
                  child: PrimaryText(text: AppStrings.unknownFailure),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class EditView extends StatefulWidget {
  const EditView({
    required this.postCubit,
    required this.post,
    required this.postTags,
    super.key,
  });
  final Post post;
  final List<String> postTags;
  final PostCubit postCubit;

  @override
  State<EditView> createState() => _EditViewState();
}

class _EditViewState extends State<EditView> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _titleIsValid = false;
  bool _descriptionIsValid = false;
  bool _tagsAreValid = false;
  String _title = '';
  String _description = '';
  String _tags = '';
  List<String> rawTags = [];

  @override
  void initState() {
    _titleController.text = widget.post.title;
    _descriptionController.text = widget.post.description;
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EditImage(
            width: 200,
            // height: 200,
            photoUrl: widget.post.photoUrl,
            collection: 'posts',
            userId: widget.post.creatorId,
            docId: widget.post.id!,
            onFileChanged: (url) => widget.postCubit
                .editField(widget.post.id!, Post.photoUrlConverter, url),
            aspectX: 4,
            aspectY: 3,
          ),
          const VerticalSpacer(),
          customTextFormField(
            controller: _titleController,
            context: context,
            label: AppStrings.title,
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
            label: AppStrings.description,
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
            label: AppStrings.tagsPrompt,
          ),
          const VerticalSpacer(),
          ActionButton(
            text: _titleIsValid || _descriptionIsValid || _tagsAreValid
                ? AppStrings.save
                : AppStrings.invalid,
            onTap: _titleIsValid || _descriptionIsValid || _tagsAreValid
                ? () {
                    try {
                      final data = Post.update(
                        title: _title,
                        description: _description,
                        tags: _tags,
                      );
                      context
                          .read<PostCubit>()
                          .updatePost(widget.post.id!, data);
                    } catch (e) {
                      if (!context.mounted) return;
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
