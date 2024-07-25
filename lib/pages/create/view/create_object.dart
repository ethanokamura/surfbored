import 'dart:io';
import 'dart:typed_data';
import 'package:app_ui/app_ui.dart';
import 'package:boards_repository/boards_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:rando/pages/create/cubit/create_cubit.dart';
import 'package:user_repository/user_repository.dart';

class CreateObject extends StatelessWidget {
  const CreateObject({required this.type, super.key});
  final String type;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateCubit(
        boardsRepository: context.read<BoardsRepository>(),
        itemsRepository: context.read<ItemsRepository>(),
      ),
      child: CreateObjectView(type: type),
    );
  }
}

class CreateObjectView extends StatefulWidget {
  const CreateObjectView({required this.type, super.key});
  final String type;
  @override
  State<CreateObjectView> createState() => _CreateObjectViewState();
}

class _CreateObjectViewState extends State<CreateObjectView> {
  // text controller
  final textController = TextEditingController();

  // images
  Uint8List? pickedImage;

  // loader
  bool isLoading = false;

  // Placeholder data for new item
  String titleText = 'title';
  String descriptionText = 'description';
  String tagsText = 'tags';
  List<String> tags = [];
  String docID = '';
  String? imgURL;

  File? imageFile;
  String? filename;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateCubit, CreateState>(
      listener: (context, state) {
        if (state.isLoading) {
          setState(() => isLoading = true);
        } else {
          setState(() {
            isLoading = false;
          });
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.successMessage!)),
            );
            Navigator.pop(context);
          }
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        }
      },
      builder: (context, state) {
        return isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  UploadImageWidget(
                    width: 200,
                    height: 200,
                    imgURL: imgURL,
                    onFileChanged: (file, filename) {
                      setState(() {
                        imageFile = file;
                        this.filename = filename;
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

                  // edit tags
                  if (widget.type == 'items')
                    Column(
                      children: [
                        CustomInputField(
                          label: 'tags',
                          text: tagsText,
                          onPressed: () => editField('tags'),
                        ),
                        const VerticalSpacer(),
                        TagListWidget(tags: tags),
                      ],
                    ),
                  const VerticalSpacer(),

                  // edit post
                  ActionButton(
                    inverted: true,
                    onTap: () {
                      context.read<CreateCubit>().createItem(
                            userID: UserRepository().getCurrentUserID(),
                            type: widget.type,
                            title: titleText,
                            description: descriptionText,
                            tags: tags,
                            imageFile: imageFile,
                            filename: filename,
                          );
                    },
                    text: 'Create',
                  ),
                ],
              );
      },
    );
  }

  // create list of tags
  List<String> createTags(String tagList) {
    return tagList.split(' ');
  }

  // dynamic input length maximum
  int maxInputLength(String field) {
    if (field == 'title') return 30;
    if (field == 'description') return 150;
    return 50;
  }

  Future<void> editField(String field) async {
    if (field == 'title' && field != titleText) {
      textController.text = titleText;
    } else if (field == 'description' && field != descriptionText) {
      textController.text = descriptionText;
    } else if (field == 'tags' && field != tagsText) {
      textController.text = tagsText;
    }
    await editTextField(context, field, maxInputLength(field), textController);
    // update field
    if (textController.text.trim().isNotEmpty) {
      if (field == 'tags') {
        tags = createTags(textController.text);
      }
      setState(() {
        if (field == 'title') {
          titleText = textController.text;
        } else if (field == 'description') {
          descriptionText = textController.text;
        } else {
          tagsText = textController.text;
        }
      });
      textController.clear();
    }
  }
}
