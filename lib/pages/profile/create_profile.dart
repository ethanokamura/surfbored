// dart packages
import 'package:flutter/material.dart';

// utils
import 'package:rando/services/firestore.dart';

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({super.key});

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final TextEditingController usernameTextController = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();
  bool isLoading = false;
  String? errorMessage;

  void returnToHome() {
    Navigator.pop(context);
  }

  void submitUsername() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    String username = usernameTextController.text.trim();
    if (username.isEmpty) {
      setState(() {
        errorMessage = "Username cannot be empty";
        isLoading = false;
      });
      return;
    }
    bool isUnique = await firestoreService.isUsernameUnique(username);
    if (isUnique) {
      await firestoreService.saveUsername(username);
      // go back to previous screen
      returnToHome();
    } else {
      setState(() {
        errorMessage = "Username is already taken";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Username'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: usernameTextController,
              decoration: InputDecoration(
                labelText: "Username",
                errorText: errorMessage,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: submitUsername,
                child: const Text("Submit"),
              ),
          ],
        ),
      ),
    );
  }
}
