// dart packages
import 'dart:typed_data';
import 'package:flutter/material.dart';

// utils
import 'package:rando/services/firestore/firestore.dart';
import 'package:rando/services/models.dart';
import 'package:rando/services/storage.dart';
import 'package:rando/utils/methods.dart';
import 'package:rando/services/firestore/board_service.dart';

// components
import 'package:rando/components/images/edit_image.dart';
import 'package:rando/components/text/text_box.dart';

class EditBoardScreen extends StatefulWidget {
  final String boardID;
  const EditBoardScreen({super.key, required this.boardID});

  @override
  State<EditBoardScreen> createState() => _EditBoardScreenState();
}

class _EditBoardScreenState extends State<EditBoardScreen> {
  // utility references
  BoardService boardService = BoardService();
  FirestoreService firestoreService = FirestoreService();
  StorageService firebaseStorage = StorageService();

  // text controller
  final textController = TextEditingController();
  Uint8List? pickedImage;

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
        // update in firestore
        await firestoreService.db
            .collection('boards')
            .doc(widget.boardID)
            .update({field: textController.text});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Item'),
      ),
      body: StreamBuilder<BoardData>(
        stream: boardService.getBoardStream(widget.boardID),
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
            BoardData boardData = snapshot.data!;
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
                        itemID: boardData.id,
                        imgURL: boardData.imgURL,
                      ),
                      const SizedBox(height: 20),
                      MyTextBox(
                        text: boardData.title,
                        label: "title",
                        onPressed: () => editField('title'),
                      ),
                      const SizedBox(height: 20),
                      MyTextBox(
                        text: boardData.description,
                        label: "description",
                        onPressed: () => editField('description'),
                      ),
                      const SizedBox(height: 20),
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
