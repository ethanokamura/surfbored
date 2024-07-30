import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:rando/pages/posts/cubit/post_cubit.dart';

class EditPostPage extends StatefulWidget {
  const EditPostPage({
    required this.postID,
    super.key,
  });
  final String postID;
  static MaterialPage<void> page({required String postID}) {
    return MaterialPage<void>(
      child: EditPostPage(postID: postID),
    );
  }

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  @override
  void initState() {
    super.initState();
    context.read<PostCubit>().streamPost(widget.postID);
  }

  @override
  Widget build(BuildContext context) {
    final postCubit = context.read<PostCubit>();
    return CustomPageView(
      top: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Edit Post'),
      ),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          // load
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isLoaded || state.isEdited) {
            return EditView(
              post: state.post,
              postCubit: postCubit,
            );
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }
}

class EditView extends StatelessWidget {
  const EditView({required this.postCubit, required this.post, super.key});
  final Post post;
  final PostCubit postCubit;
  @override
  Widget build(BuildContext context) {
    return BlocListener<PostCubit, PostState>(
      listener: (context, state) {
        if (state.isEdited) {
          // Show a success message or navigate back
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Post updated successfully')),
          );
        }
      },
      child: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                EditImage(
                  width: 200,
                  height: 200,
                  photoURL: post.photoURL,
                  collection: 'users',
                  docID: post.uid,
                  onFileChanged: (url) =>
                      postCubit.editField(post.id, 'photoURL', url),
                ),
                const VerticalSpacer(),
                CustomTextBox(
                  text: post.title,
                  label: 'title',
                  onPressed: () async {
                    final newValue = await editTextField(
                      context,
                      'title',
                      30,
                      TextEditingController(),
                    );
                    if (newValue != null && context.mounted) {
                      await postCubit.editField(post.id, 'title', newValue);
                    }
                  },
                ),
                const VerticalSpacer(),
                CustomTextBox(
                  text: post.description,
                  label: 'description',
                  onPressed: () async {
                    final newValue = await editTextField(
                      context,
                      'description',
                      150,
                      TextEditingController(),
                    );
                    if (newValue != null && context.mounted) {
                      await postCubit.editField(
                          post.id, 'description', newValue);
                    }
                  },
                ),
                const VerticalSpacer(),
                CustomTextBox(
                  text: 'tags',
                  label: 'tags',
                  onPressed: () async {
                    final newValue = await editTextField(
                      context,
                      'tags',
                      50,
                      TextEditingController(),
                    );
                    if (newValue != null && context.mounted) {
                      final trimmed = newValue.trim();
                      final tags = trimmed.split(' ');
                      await postCubit.editField(post.id, 'tags', tags);
                    }
                  },
                ),
                const VerticalSpacer(),
                TagList(tags: post.tags),
              ],
            ),
          );
        },
      ),
    );
  }
}
