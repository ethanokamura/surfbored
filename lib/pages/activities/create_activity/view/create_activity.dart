import 'dart:io';
import 'dart:typed_data';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:rando/pages/activities/cubit/activity_cubit.dart';
import 'package:user_repository/user_repository.dart';

class CreateActivityPage extends StatelessWidget {
  const CreateActivityPage({super.key});
  static Page<dynamic> page() =>
      const MaterialPage<void>(child: CreateActivityPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create An Activity!')),
      body: CustomPageView(
        top: true,
        child: BlocProvider(
          create: (context) => ItemCubit(
            userRepository: context.read<UserRepository>(),
            itemsRepository: context.read<ItemsRepository>(),
          ),
          child: const CreateActivity(),
        ),
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
    return BlocBuilder<ItemCubit, ItemState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.isCreated) {
          return const Center(child: Text('Item created successfully!'));
        } else if (state.isEmpty) {
          return const Center(child: Text('This board is empty.'));
        } else if (state.isFailure) {
          return const Center(child: Text('Something went wrong'));
        } else {
          return ListView(
            children: [
              // upload image
              UploadImageWidget(
                width: 200,
                height: 200,
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

              // edit tags
              Column(
                children: [
                  CustomInputField(
                    label: 'tags',
                    text: tagsText,
                    onPressed: () => editField('tags'),
                  ),
                  const VerticalSpacer(),
                  TagList(tags: tags),
                ],
              ),
              const VerticalSpacer(),

              // submit
              ActionButton(
                inverted: true,
                onTap: () {
                  context.read<ItemCubit>().createItem(
                        userID:
                            context.read<UserRepository>().getCurrentUserID(),
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

  // create list of tags
  List<String> createTags(String tagList) {
    final tags = tagList.trim();
    return tags.split(' ');
  }

  // dynamic input length maximum
  int maxInputLength(String field) {
    switch (field) {
      case 'title':
        return 30;
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
    } else if (field == 'tags' && field != tagsText) {
      textController.text = tagsText;
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
        } else {
          tags = createTags(textController.text);
        }
      });
      textController.clear();
    }
  }
}
