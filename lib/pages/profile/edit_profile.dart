// dart packages
import 'package:flutter/material.dart';

// utils
import 'package:rando/core/services/auth_service.dart';
import 'package:rando/core/services/firestore.dart';
import 'package:rando/core/models/models.dart';
import 'package:rando/core/services/user_service.dart';

// components
import 'package:rando/shared/images/edit_image.dart';
import 'package:rando/shared/widgets/text/text_box.dart';
import 'package:rando/core/services/storage_service.dart';
import 'package:rando/core/utils/methods.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // firestore service
  FirestoreService firestoreService = FirestoreService();

  // storage service
  StorageService storageService = StorageService();

  // user
  var user = AuthService().user!;
  UserService userService = UserService();

  // images
  String imgURL = '';

  // Placeholder data for new item
  String usernameText = 'username';
  String nameText = 'name';
  String bioText = 'bio';

  // text controller
  final textController = TextEditingController();

  // dynamic input length maximum
  int maxInputLength(String field) {
    if (field == "username") return 20;
    if (field == "bio") return 150;
    return 50;
  }

  // edit user data
  Future<void> editField(String field) async {
    await editTextField(context, field, maxInputLength(field), textController);
    if (textController.text.trim().isNotEmpty) {
      // update in firestore
      await userService.db
          .collection('users')
          .doc(user.uid)
          .update({field: textController.text});
      if (field == 'username') {
        await userService.db
            .collection('usernames')
            .doc(user.uid)
            .update({field: textController.text});
      }
      textController.clear();
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
        title: const Text('Profile'),
      ),
      body: StreamBuilder<UserData>(
        stream: userService.getUserStream(user.uid),
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
            UserData userData = snapshot.data!;
            imgURL = userData.imgURL;
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
                        imgURL: userData.imgURL,
                        collection: 'users',
                        docID: user.uid,
                        onFileChanged: (url) {
                          setState(() {
                            imgURL = url;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      MyTextBox(
                        text: userData.username,
                        label: "username",
                        onPressed: () => editField('username'),
                      ),
                      const SizedBox(height: 20),
                      MyTextBox(
                        text: userData.name,
                        label: "name",
                        onPressed: () => editField('name'),
                      ),
                      const SizedBox(height: 20),
                      MyTextBox(
                        text: userData.website,
                        label: "website",
                        onPressed: () => editField('website'),
                      ),
                      const SizedBox(height: 20),
                      MyTextBox(
                        text: userData.bio,
                        label: "bio",
                        onPressed: () => editField('bio'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            // no data found
            return const Text("no user found");
          }
        },
      ),
    );
  }
}
