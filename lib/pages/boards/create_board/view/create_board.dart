import 'dart:io';
import 'dart:typed_data';
import 'package:app_ui/app_ui.dart';
import 'package:boards_repository/boards_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/pages/boards/cubit/board_cubit.dart';
import 'package:user_repository/user_repository.dart';

class CreateBoardPage extends StatelessWidget {
  const CreateBoardPage({super.key});
  static Page<dynamic> page() =>
      const MaterialPage<void>(child: CreateBoardPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create A Board!')),
      body: CustomPageView(
        top: true,
        child: BlocProvider(
          create: (context) => BoardCubit(
            userRepository: context.read<UserRepository>(),
            boardsRepository: context.read<BoardsRepository>(),
          ),
          child: const CreateBoard(),
        ),
      ),
    );
  }
}

class CreateBoard extends StatefulWidget {
  const CreateBoard({super.key});
  @override
  State<CreateBoard> createState() => _CreateBoardState();
}

class _CreateBoardState extends State<CreateBoard> {
  // text controller
  final textController = TextEditingController();
  Uint8List? pickedImage;

  bool isLoading = false;

  String titleText = 'title';
  String descriptionText = 'description';
  String docID = '';
  String? photoURL;

  File? imageFile;
  String? filename;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BoardCubit, BoardState>(
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

              // submit
              ActionButton(
                inverted: true,
                onTap: () {
                  context.read<BoardCubit>().createBoard(
                        userID:
                            context.read<UserRepository>().getCurrentUserID(),
                        title: titleText,
                        description: descriptionText,
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
