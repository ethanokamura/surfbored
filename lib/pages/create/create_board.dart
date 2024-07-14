// dart packages
import 'dart:typed_data';
import 'package:flutter/material.dart';

// utils
import 'package:rando/services/auth.dart';
import 'package:rando/services/firestore/firestore.dart';
import 'package:rando/services/firestore/item_service.dart';
import 'package:rando/services/models.dart';
import 'package:rando/services/storage.dart';
import 'package:rando/utils/methods.dart';

// components
import 'package:rando/components/containers/tag_list.dart';
import 'package:rando/components/images/upload_image.dart';
import 'package:rando/components/text/input_field.dart';
import 'package:rando/components/buttons/custom_button.dart';

class CreateBoardScreen extends StatefulWidget {
  const CreateBoardScreen({super.key});

  @override
  State<CreateBoardScreen> createState() => _CreateBoardScreenState();
}

class _CreateBoardScreenState extends State<CreateBoardScreen> {
  // utility references
  var user = AuthService().user;
  ItemService itemService = ItemService();
  FirestoreService firestoreService = FirestoreService();
  StorageService firebaseStorage = StorageService();

  // text controller
  final textController = TextEditingController();
  Uint8List? pickedImage;

  // Placeholder data for new item
  String titleText = 'title';
  String descriptionText = 'description';
  String tagsText = 'tags';
  List<String> tags = [];

  @override
  void initState() {
    super.initState();
  }

  // create list of tags
  List<String> createTags(String tagList) {
    tags = tagList.split(' ');
    return tags;
  }

  // dynamic input length maximum
  int maxInputLength(String field) {
    if (field == "title") return 20;
    if (field == "description") return 150;
    return 50;
  }

  Future<void> editField(String field) async {
    if (field == "title" && field != titleText) {
      textController.text = titleText;
    } else if (field == "description" && field != descriptionText) {
      textController.text = descriptionText;
    } else if (field == "tags" && field != tagsText) {
      textController.text = tagsText;
    }
    await editTextField(context, field, maxInputLength(field), textController);
    // update field
    if (textController.text.trim().isNotEmpty) {
      if (field == "tags") {
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

  // post data to firebase and pop screen
  void createItem() async {
    try {
      // create a new post to get the itemID
      String itemID = await itemService.createItem(ItemData(
        title: titleText,
        description: descriptionText,
        uid: user!.uid,
        tags: tags,
        likes: 0,
      ));
      // upload image to firebase
      if (pickedImage != null) {
        String imageURL = 'items/$itemID/itemimage.png';
        firebaseStorage.uploadFile(imageURL, pickedImage!);
        await firestoreService.setPhotoURL('items', itemID, imageURL);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Failed to create item. Please try again.")),
        );
      }
    }
  }

  @override
  void dispose() {
    // Dispose controllers
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create An Activity"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // edit image
                UploadImageWidget(
                  width: 200,
                  height: 200,
                  imgURL: '',
                  onImagePicked: (image) {
                    setState(() {
                      pickedImage = image;
                    });
                  },
                ),
                const SizedBox(height: 20),
                // edit title
                MyInputField(
                  label: "title",
                  text: titleText,
                  onPressed: () => editField("title"),
                ),
                const SizedBox(height: 20),
                // edit description
                MyInputField(
                  label: "info",
                  text: descriptionText,
                  onPressed: () => editField("description"),
                ),
                const SizedBox(height: 20),
                // edit tags
                MyInputField(
                  label: "tags",
                  text: tagsText,
                  onPressed: () => editField("tags"),
                ),
                const SizedBox(height: 20),
                TagListWidget(tags: tags),
                const SizedBox(height: 20),
                // edit post
                CustomButton(
                  inverted: true,
                  onTap: createItem,
                  text: "Create",
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
