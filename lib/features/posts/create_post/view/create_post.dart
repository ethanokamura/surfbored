import 'dart:io';
import 'dart:typed_data';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:rando/features/posts/cubit/post_cubit.dart';
import 'package:rando/features/tags/tags.dart';
import 'package:user_repository/user_repository.dart';

class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key});
  static Page<dynamic> page() =>
      const MaterialPage<void>(child: CreatePostPage());

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      top: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const AppBarText(text: 'Create An Activity!'),
      ),
      body: BlocProvider(
        create: (context) => PostCubit(
          postRepository: context.read<PostRepository>(),
        ),
        child: const CreateActivity(),
      ),
    );
  }
}

class CreateActivity extends StatefulWidget {
  const CreateActivity({super.key});
  @override
  State<CreateActivity> createState() => _CreateActivityState();
}

class _CreateActivityState extends State<CreateActivity> {
  // text controller
  final textController = TextEditingController();
  Uint8List? pickedImage;

  bool isLoading = false;

  String titleText = 'title';
  String descriptionText = 'description';
  String tagsText = 'tags';
  List<String> tags = [];
  String docID = '';
  String? photoURL;

  File? imageFile;
  String? filename;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCubit, PostState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.isCreated) {
          return const Center(
            child: PrimaryText(text: 'Post created successfully!'),
          );
        } else if (state.isEmpty) {
          return const Center(
            child: PrimaryText(text: 'Post is empty'),
          );
        } else if (state.isFailure) {
          return const Center(
            child: PrimaryText(text: 'Something went wrong.'),
          );
        } else {
          return ListView(
            children: [
              // upload image
              UploadImageWidget(
                width: 200,
                photoURL: photoURL,
                onFileChanged: (file) {
                  setState(() {
                    imageFile = file;
                  });
                },
              ),
              const VerticalSpacer(),

              // edit title
              CustomInputField(
                label: 'title',
                text: titleText,
                onPressed: () => editField('title'),
              ),
              const VerticalSpacer(),

              // edit description
              CustomInputField(
                label: 'info',
                text: descriptionText,
                onPressed: () => editField('description'),
              ),
              const VerticalSpacer(),
              EditTagsBox(
                tags: tags,
                updateTags: (newTags) => setState(() {
                  tags = newTags;
                }),
              ),
              const VerticalSpacer(),

              // submit
              ActionButton(
                inverted: true,
                onTap: () {
                  context.read<PostCubit>().createPost(
                        userID: context.read<UserRepository>().user.uid,
                        title: titleText,
                        description: descriptionText,
                        tags: tags,
                        imageFile: imageFile,
                      );
                  Navigator.pop(context);
                },
                text: 'Create',
              ),
            ],
          );
        }
      },
    );
  }

  // dynamic input length maximum
  int maxInputLength(String field) {
    switch (field) {
      case 'title':
        return 40;
      case 'description':
        return 150;
      default:
        return 50;
    }
  }

  Future<void> editField(String field) async {
    if (field == 'title' && field != titleText) {
      textController.text = titleText;
    } else if (field == 'description' && field != descriptionText) {
      textController.text = descriptionText;
    }

    // edit
    await editTextField(context, field, maxInputLength(field), textController);

    // update field
    if (textController.text.trim().isNotEmpty) {
      setState(() {
        if (field == 'title') {
          titleText = textController.text;
        } else if (field == 'description') {
          descriptionText = textController.text;
        }
      });
      textController.clear();
    }
  }
}
