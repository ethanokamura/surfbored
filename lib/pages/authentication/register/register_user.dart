// dart packages
import 'package:flutter/material.dart';
import 'package:rando/shared/widgets/buttons/defualt_button.dart';

// utils
import 'package:rando/core/services/user_service.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  final TextEditingController textController = TextEditingController();
  final UserService userService = UserService();
  bool isLoading = false;
  String? errorMessage;

  void returnToHome() {
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  void submitUsername() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    String username = textController.text.trim();
    if (username.isEmpty) {
      setState(() {
        errorMessage = "Username cannot be empty";
        isLoading = false;
      });
      return;
    }
    bool isUnique = await userService.isUsernameUnique(username);
    if (isUnique) {
      await userService.createUser(username);
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
  void dispose() {
    // Dispose controllers
    textController.dispose();
    super.dispose();
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
              controller: textController,
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
              DefualtButton(
                inverted: true,
                onTap: submitUsername,
                text: "Confirm",
              ),
          ],
        ),
      ),
    );
  }
}
