// dart packages
import 'package:app_ui/app_ui.dart';
// import 'package:boards_repository/boards_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:rando/pages/posts/cubit/activity_cubit.dart';

class EditPostPage extends StatelessWidget {
  const EditPostPage({required this.postID, super.key});
  final String postID;
  static MaterialPage<void> page({required String postID}) {
    return MaterialPage<void>(
      child: EditPostPage(postID: postID),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      top: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Edit Post'),
      ),
      body: BlocProvider(
        create: (_) => PostCubit(
          postRepository: context.read<PostRepository>(),
          // boardsRepository: context.read<BoardsRepository>(),
        )..streamPost(postID),
        child: BlocBuilder<PostCubit, PostState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.isLoaded) {
              return EditView(post: state.post);
            } else if (state.isEmpty) {
              return const Center(child: Text('This board is empty.'));
            } else {
              return const Center(child: Text('Something went wrong'));
            }
          },
        ),
      ),
    );
  }
}

class EditView extends StatelessWidget {
  const EditView({required this.post, super.key});
  final Post post;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          EditImage(
            width: 200,
            height: 200,
            photoURL: post.photoURL,
            collection: 'users',
            docID: post.uid,
            onFileChanged: (url) {
              context.read<PostCubit>().editField(post.id, 'photoURL', url);
            },
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
                await context
                    .read<PostCubit>()
                    .editField(post.id, 'title', newValue);
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
                await context
                    .read<PostCubit>()
                    .editField(post.id, 'description', newValue);
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
                await context
                    .read<PostCubit>()
                    .editField(post.id, 'tags', newValue);
              }
            },
          ),
          const VerticalSpacer(),
          TagList(tags: post.tags),
        ],
      ),
    );
  }
}
