import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
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
    return CustomPageView(
      top: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const AppBarText(text: AppStrings.editPost),
      ),
      body: BlocListener<PostCubit, PostState>(
        listener: (context, state) {
          if (state.isUpdated) {
            // Show a success message or navigate back
            context.showSnackBar(AppStrings.updatedPost);
          }
        },
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
                child: PrimaryText(text: AppStrings.deletePost),
              );
            }
            return const Center(
              child: PrimaryText(text: AppStrings.fetchFailure),
            );
          },
        ),
      ),
    );
  }
}

class EditView extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EditImage(
            width: 200,
            // height: 200,
            photoUrl: post.photoUrl,
            collection: 'posts',
            docID: post.id!,
            onFileChanged: (url) =>
                postCubit.editField(post.id!, 'photo_url', url),
          ),
          const VerticalSpacer(),
          EditField(
            field: 'title',
            value: post.title,
            postId: post.id!,
          ),
          const VerticalSpacer(),
          EditField(
            field: 'description',
            value: post.description,
            postId: post.id!,
          ),
          const VerticalSpacer(),
          EditField(
            field: 'website',
            value: post.websiteUrl,
            postId: post.id!,
          ),
          const VerticalSpacer(),
          EditTagsBox(
            tags: postTags,
            updateTags: (tags) => postCubit.updateTags(post.id!, tags),
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
    required this.postId,
    super.key,
  });
  final String field;
  final String value;
  final int postId;
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
          await context.read<PostCubit>().editField(postId, field, newValue);
        }
      },
    );
  }
}
