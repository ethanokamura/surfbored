import 'dart:io';
import 'dart:typed_data';
import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/create/cubit/create_cubit.dart';
import 'package:surfbored/features/tags/tags.dart';
import 'package:user_repository/user_repository.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});
  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  // text controller
  final textController = TextEditingController();
  Uint8List? pickedImage;

  bool isLoading = false;

  String titleText = '';
  String descriptionText = '';
  String linkText = '';
  List<String> tags = [];
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
              text: isPublic ? ButtonStrings.isPublic : ButtonStrings.isPrivate,
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
          text: titleText.isEmpty ? CreateStrings.titlePrompt : titleText,
          onPressed: () => editField(Post.titleConverter),
        ),
        const VerticalSpacer(),

        // edit description
        CustomTextBox(
          label: 'description',
          text: descriptionText.isEmpty
              ? CreateStrings.descriptionPrompt
              : descriptionText,
          onPressed: () => editField(Post.descriptionConverter),
        ),
        const VerticalSpacer(),

        // edit link
        CustomTextBox(
          label: 'link',
          text: linkText.isEmpty ? CreateStrings.linkPrompt : linkText,
          onPressed: () => editField(Post.linkConverter),
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
        if (titleText.isNotEmpty)
          ActionButton(
            inverted: true,
            onTap: () {
              context.read<CreateCubit>().createPost(
                    userId: context.read<UserRepository>().user.uuid,
                    title: titleText,
                    description: descriptionText,
                    link: linkText,
                    tags: tags,
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
    if (field == Post.titleConverter && field != titleText) {
      textController.text = titleText;
    } else if (field == Post.descriptionConverter && field != descriptionText) {
      textController.text = descriptionText;
    } else if (field == Post.linkConverter && field != linkText) {
      textController.text = linkText;
    }

    // edit
    await editTextField(context, field, textController);

    // update field
    if (textController.text.trim().isNotEmpty) {
      setState(() {
        if (field == Post.titleConverter) {
          titleText = textController.text;
        } else if (field == Post.descriptionConverter) {
          descriptionText = textController.text;
        } else if (field == Post.linkConverter) {
          linkText = textController.text;
        }
      });
      textController.clear();
    }
  }
}
