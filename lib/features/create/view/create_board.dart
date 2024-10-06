import 'dart:io';
import 'dart:typed_data';
import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/create/cubit/create_cubit.dart';
import 'package:user_repository/user_repository.dart';

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
  bool isPublic = true;
  int docID = 0;
  String? photoUrl;

  File? imageFile;
  String? filename;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // upload image
        UploadImageWidget(
          width: 128,
          photoUrl: photoUrl,
          onFileChanged: (file) {
            setState(() {
              imageFile = file;
            });
          },
        ),
        const VerticalSpacer(),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            PrimaryText(
              text: isPublic ? AppStrings.isPublic : AppStrings.isPrivate,
            ),
            const HorizontalSpacer(),
            Switch(
              value: isPublic,
              onChanged: (value) => setState(() => isPublic = value),
            ),
          ],
        ),
        const VerticalSpacer(),

        // edit title
        CustomTextBox(
          label: 'title',
          text: titleText,
          onPressed: () => editField(Post.titleConverter),
        ),
        const VerticalSpacer(),

        // edit description
        CustomTextBox(
          label: 'description',
          text: descriptionText,
          onPressed: () => editField(Post.descriptionConverter),
        ),
        const VerticalSpacer(),
        // submit
        ActionButton(
          inverted: true,
          onTap: () {
            context.read<CreateCubit>().createBoard(
                  userId: context.read<UserRepository>().user.uuid,
                  title: titleText,
                  description: descriptionText,
                  isPublic: isPublic,
                  imageFile: imageFile,
                );
            Navigator.pop(context);
          },
          text: AppStrings.create,
        ),
      ],
    );
  }

  Future<void> editField(String field) async {
    if (field == Board.titleConverter && field != titleText) {
      textController.text = titleText;
    } else if (field == Board.descriptionConverter &&
        field != descriptionText) {
      textController.text = descriptionText;
    }

    // edit
    await editTextField(context, field, textController);

    // update field
    if (textController.text.trim().isNotEmpty) {
      setState(() {
        if (field == Board.titleConverter) {
          titleText = textController.text;
        } else if (field == Board.descriptionConverter) {
          descriptionText = textController.text;
        }
      });
      textController.clear();
    }
  }
}
