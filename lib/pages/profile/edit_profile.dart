// dart packages
import 'package:flutter/material.dart';

// utils
import 'package:rando/services/auth.dart';
import 'package:rando/services/models.dart';
import 'package:rando/services/firestore/user_service.dart';

// components
import 'package:rando/components/images/edit_pfp.dart';
import 'package:rando/components/text/text_box.dart';
import 'package:rando/utils/methods.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // firestore service
  UserService userService = UserService();
  var user = AuthService().user!;
  final textController = TextEditingController();

  // logout user
  void logOut({context}) async {
    await AuthService().signOut();
    // reset navigation stack
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  // dynamic input length maximum
  int maxInputLength(String field) {
    if (field == "title") return 20;
    if (field == "description") return 150;
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
            UserData? userData = snapshot.data;
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      EditProfilePicture(
                        width: 200,
                        height: 200,
                        imgURL: userData!.imgURL,
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
