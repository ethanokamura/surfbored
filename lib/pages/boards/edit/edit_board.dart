// dart packages
import 'package:flutter/material.dart';
import 'package:rando/shared/widgets/buttons/defualt_button.dart';

// utils
import 'package:rando/core/services/firestore.dart';
import 'package:rando/core/models/models.dart';
import 'package:rando/core/services/storage_service.dart';
import 'package:rando/core/utils/methods.dart';
import 'package:rando/core/services/board_service.dart';

// components
import 'package:rando/shared/images/edit_image.dart';
import 'package:rando/shared/widgets/text/text_box.dart';

class EditBoardScreen extends StatefulWidget {
  final String boardID;
  const EditBoardScreen({super.key, required this.boardID});

  @override
  State<EditBoardScreen> createState() => _EditBoardScreenState();
}

class _EditBoardScreenState extends State<EditBoardScreen> {
  // utility references
  BoardService boardService = BoardService();
  StorageService firebaseStorage = StorageService();
  FirestoreService firestoreService = FirestoreService();

  // images
  String? imgURL;

  // text controller
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Dispose controllers
    textController.dispose();
    firebaseStorage.cancelOperation();
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
            imgURL = boardData.imgURL;
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
                        imgURL: imgURL,
                        collection: 'boards',
                        docID: boardData.id,
                        onFileChanged: (url) {
                          setState(() {
                            imgURL = url;
                          });
                        },
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
                      DefualtButton(
                        inverted: true,
                        text: "Delete Board",
                        onTap: () => boardService.deleteBoard(
                          boardData.uid,
                          boardData.id,
                          boardData.imgURL,
                        ),
                      )
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
