// dart packages
import 'package:flutter/material.dart';

// utils
import 'package:rando/services/auth.dart';
import 'package:rando/services/firestore.dart';
import 'package:rando/services/models.dart';

// components
import 'package:rando/components/images/edit_pfp.dart';
import 'package:rando/components/containers/text_box.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // firestore service
  FirestoreService firestoreService = FirestoreService();
  var user = AuthService().user;

  // logout user
  void logOut({context}) async {
    await AuthService().signOut();
    // reset navigation stack
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  // edit user data
  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit $field"),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Enter new $field",
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          //cancel
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          // save
          TextButton(
            onPressed: () => Navigator.of(context).pop(newValue),
            child: const Text("Save"),
          ),
        ],
      ),
    );
    // update in firestore
    if (newValue.trim().isNotEmpty) {
      // only update if it is not empty
      await firestoreService.db
          .collection('users')
          .doc(user!.uid)
          .update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: StreamBuilder<UserData>(
        stream: firestoreService.getUserStream(),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                      text: userData.bio,
                      label: "bio",
                      onPressed: () => editField('bio'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      child: const Icon(Icons.logout),
                      onPressed: () => logOut(context: context),
                    ),
                  ],
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
