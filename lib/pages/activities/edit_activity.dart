// dart packages
import 'dart:typed_data';
import 'package:flutter/material.dart';

// utils
import 'package:rando/services/firestore/firestore.dart';
import 'package:rando/services/firestore/item_service.dart';
import 'package:rando/services/models.dart';
import 'package:rando/services/storage.dart';
import 'package:rando/utils/methods.dart';

// components
import 'package:rando/components/lists/tag_list.dart';
import 'package:rando/components/images/edit_image.dart';
import 'package:rando/components/text/text_box.dart';

class EditActivityScreen extends StatefulWidget {
  final String itemID;
  const EditActivityScreen({super.key, required this.itemID});

  @override
  State<EditActivityScreen> createState() => _EditActivityScreenState();
}

class _EditActivityScreenState extends State<EditActivityScreen> {
  // utility references
  ItemService itemService = ItemService();
  FirestoreService firestoreService = FirestoreService();
  StorageService firebaseStorage = StorageService();

  // text controller
  final textController = TextEditingController();
  Uint8List? pickedImage;

  List<String> tags = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Dispose controllers
    textController.dispose();
    firebaseStorage
        .cancelOperation(); // Example: Cancel any ongoing storage operations
    super.dispose();
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
    try {
      await editTextField(
        context,
        field,
        maxInputLength(field),
        textController,
      );
      // update item data
      if (textController.text.trim().isNotEmpty) {
        // create tags if applicable
        if (field == "tags") tags = createTags(textController.text);
        // update in firestore
        await firestoreService.db
            .collection('items')
            .doc(widget.itemID)
            .update({field: textController.text});
        if (field == 'tags') {
          await firestoreService.db
              .collection('items')
              .doc(widget.itemID)
              .update({'tags': tags});
        }
      }
      // if (mounted) Navigator.pop(context);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Success Editing $field!")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to edit $field. Please try again.")),
        );
      }
    }
  }

  void deleteItem(String userID, String itemID, String imgPath) async {
    await itemService.deleteItem(userID, itemID, imgPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Item'),
      ),
      body: StreamBuilder<ItemData>(
        stream: itemService.getItemStream(widget.itemID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // loading
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // error
            return Center(
              child: Text("ERROR: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.hasData) {
            // has data
            ItemData itemData = snapshot.data!;
            tags = itemData.tags;
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      EditImage(
                        width: 200,
                        height: 200,
                        docID: itemData.id,
                        collection: 'items',
                        imgURL: itemData.imgURL,
                      ),
                      const SizedBox(height: 20),
                      MyTextBox(
                        text: itemData.title,
                        label: "title",
                        onPressed: () => editField('title'),
                      ),
                      const SizedBox(height: 20),
                      MyTextBox(
                        text: itemData.description,
                        label: "description",
                        onPressed: () => editField('description'),
                      ),
                      const SizedBox(height: 20),
                      MyTextBox(
                        text: "tags",
                        label: "tags",
                        onPressed: () => editField('tags'),
                      ),
                      const SizedBox(height: 20),
                      TagListWidget(tags: tags),
                    ],
                  ),
                ),
              ),
            );
          } else {
            // no data found
            return const Text("no item found");
          }
        },
      ),
    );
  }
}
