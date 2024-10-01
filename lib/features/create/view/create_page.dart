import 'dart:io';
import 'dart:typed_data';
import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/create/cubit/create_cubit.dart';
import 'package:surfbored/features/tags/tags.dart';
import 'package:tag_repository/tag_repository.dart';
import 'package:user_repository/user_repository.dart';

class CreatePage extends StatelessWidget {
  const CreatePage({required this.type, super.key});

  static MaterialPage<void> page({required String type}) {
    return MaterialPage<void>(
      child: CreatePage(type: type),
    );
  }

  final String type;

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      top: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: AppBarText(
          text:
              type == 'post' ? AppStrings.createPost : AppStrings.createdBoard,
        ),
      ),
      body: BlocProvider(
        create: (context) => CreateCubit(
          postRepository: context.read<PostRepository>(),
          boardRepository: context.read<BoardRepository>(),
          tagRepository: context.read<TagRepository>(),
        ),
        child: CreatePost(type: type),
      ),
    );
  }
}

class CreatePost extends StatefulWidget {
  const CreatePost({required this.type, super.key});
  final String type;
  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  // text controller
  final textController = TextEditingController();
  Uint8List? pickedImage;

  bool isLoading = false;

  String titleText = 'title';
  String descriptionText = 'description';
  String websiteText = 'website';
  String tagsText = 'tags';
  List<String> tags = [];
  String docID = '';
  String? photoUrl;

  File? imageFile;
  String? filename;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCubit, CreateState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.isCreated) {
          return const Center(
            child: PrimaryText(text: AppStrings.createSuccess),
          );
        } else if (state.isEmpty) {
          return const Center(
            child: PrimaryText(text: AppStrings.emptyPost),
          );
        } else if (state.isFailure) {
          return const Center(
            child: PrimaryText(text: AppStrings.fetchFailure),
          );
        } else {
          return ListView(
            children: [
              // upload image
              UploadImageWidget(
                width: 200,
                photoUrl: photoUrl,
                onFileChanged: (file) {
                  setState(() {
                    imageFile = file;
                  });
                },
              ),
              const VerticalSpacer(),

              // edit title
              CustomTextBox(
                label: 'title',
                text: titleText,
                onPressed: () => editField('title'),
              ),
              const VerticalSpacer(),

              // edit description
              CustomTextBox(
                label: 'description',
                text: descriptionText,
                onPressed: () => editField('description'),
              ),
              const VerticalSpacer(),

              // edit website
              if (widget.type == 'post')
                CustomTextBox(
                  label: 'website',
                  text: websiteText,
                  onPressed: () => editField('website'),
                ),
              if (widget.type == 'post') const VerticalSpacer(),

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
                  context.read<CreateCubit>().create(
                        type: widget.type.toLowerCase(),
                        userID: context.read<UserRepository>().user.id,
                        title: titleText,
                        description: descriptionText,
                        website: websiteText,
                        tags: tags,
                        imageFile: imageFile,
                      );
                  Navigator.pop(context);
                },
                text: AppStrings.create,
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
    } else if (field == 'website' && field != websiteText) {
      textController.text = websiteText;
    }

    // edit
    await editTextField(context, field, textController);

    // update field
    if (textController.text.trim().isNotEmpty) {
      setState(() {
        if (field == 'title') {
          titleText = textController.text;
        } else if (field == 'description') {
          descriptionText = textController.text;
        } else if (field == 'website') {
          websiteText = textController.text;
        }
      });
      textController.clear();
    }
  }
}
