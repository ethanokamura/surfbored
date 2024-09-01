import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:rando/features/posts/cubit/post_cubit.dart';
import 'package:rando/features/tags/tags.dart';

class EditPostPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    context.read<PostCubit>().fetchPost(postID);
    return CustomPageView(
      top: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const AppBarText(text: 'Edit Post'),
      ),
      body: BlocListener<PostCubit, PostState>(
        listener: (context, state) {
          if (state.isUpdated) {
            // Show a success message or navigate back
            context.showSnackBar('Post updated successfully!');
          }
        },
        child: BlocBuilder<PostCubit, PostState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.isLoaded) {
              return EditView(
                post: state.post,
                postCubit: context.read<PostCubit>(),
              );
            } else if (state.isDeleted) {
              return const Center(
                child: PrimaryText(text: 'Deleted board.'),
              );
            }
            return const Center(
              child: PrimaryText(text: 'Something went wrong'),
            );
          },
        ),
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EditImage(
            width: 200,
            // height: 200,
            photoURL: post.photoURL,
            collection: 'users',
            docID: post.uid,
            onFileChanged: (url) =>
                postCubit.editField(post.id, 'photoURL', url),
          ),
          const VerticalSpacer(),
          EditField(
            field: 'title',
            value: post.title,
            boardID: post.id,
          ),
          const VerticalSpacer(),
          EditField(
            field: 'description',
            value: post.description,
            boardID: post.id,
          ),
          const VerticalSpacer(),
          EditTagsBox(
            tags: post.tags,
            updateTags: (tags) => postCubit.editField(post.id, 'tags', tags),
          ),
        ],
      ),
    );
  }
}

class EditField extends StatelessWidget {
  const EditField({
    required this.field,
    required this.value,
    required this.boardID,
    super.key,
  });
  final String field;
  final String value;
  final String boardID;
  @override
  Widget build(BuildContext context) {
    return CustomTextBox(
      text: value,
      label: field,
      onPressed: () async {
        final newValue = await editTextField(
          context,
          field,
          30,
          TextEditingController(),
        );
        if (newValue != null && context.mounted) {
          await context.read<PostCubit>().editField(boardID, field, newValue);
        }
      },
    );
  }
}
